{ config, lib, pkgs, ... }:

{
  processes.garage = let
    settings = {
      metadata_dir = "${config.env.DEVENV_STATE}/garage/metadata";
      data_dir = "${config.env.DEVENV_STATE}/garage/data";
      db_engine = "lmdb";

      replication_mode = "none";

      rpc_bind_addr = "[::]:3901";
      rpc_public_addr = "127.0.0.1:3901";
      rpc_secret_file = "${config.env.DEVENV_STATE}/garage/rpc_secret";

      s3_api = {
        s3_region = "garage";
        api_bind_addr = "[::]:3900";
        root_domain = ".s3.garage.localhost";
      };

      s3_web = {
        bind_addr = "[::]:3902";
        root_domain = ".web.garage.localhost";
        index = "index.html";
      };

      k2v_api = { api_bind_addr = "[::]:3904"; };

      admin = {
        api_bind_addr = "0.0.0.0:3903";
        admin_token_file = "${config.env.DEVENV_STATE}/garage/admin_token";
      };
    };
    configFile = (pkgs.formats.toml { }).generate "garage.toml" settings;
  in {
    exec = "${pkgs.writeShellScript "garage-start" ''
      mkdir -p ${config.env.DEVENV_STATE}/garage
      ln -sf ${configFile} ${config.env.DEVENV_STATE}/garage/config.toml
      (
        umask 0077
        [ -f ${settings.rpc_secret_file} ] || ( ${pkgs.openssl}/bin/openssl rand -hex 32 > ${settings.rpc_secret_file} )
        [ -f ${settings.admin.admin_token_file} ] || ( ${pkgs.openssl}/bin/openssl rand -hex 32 > ${settings.admin.admin_token_file} )
      )
      exec ${pkgs.garage}/bin/garage -c ${configFile} server
    ''}";
  };

  packages = [
    (pkgs.writeShellScriptBin "garage"
      "${pkgs.garage}/bin/garage -c ${config.env.DEVENV_STATE}/garage/config.toml $@")
  ];
}
