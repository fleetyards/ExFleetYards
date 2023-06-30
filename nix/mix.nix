{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    appsignal = buildMix rec {
      name = "appsignal";
      version = "2.7.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "11hzdq3msla5hikqq5ziph49vycd98j5s7nz0rknqnb3p841sfgk";
      };

      beamDeps = [ decimal decorator hackney jason telemetry ];
    };

    ash = buildMix rec {
      name = "ash";
      version = "2.9.29";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ivhl3z29h16fbk52fi9vqsj8sq7f5dcq918b1g781r1v681rdjv";
      };

      beamDeps = [ comparable decimal ecto ets jason picosat_elixir plug spark stream_data telemetry ];
    };

    ash_json_api = buildMix rec {
      name = "ash_json_api";
      version = "0.31.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hri0b4y9g2jlmfkbbnc3yd1qi8mllikryr9l4rbqsg9fw0aaywf";
      };

      beamDeps = [ ash jason json_xema open_api_spex plug ];
    };

    ash_phoenix = buildMix rec {
      name = "ash_phoenix";
      version = "1.2.14";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1l7fjbxm4vkjihf7if9100y8xyik9xp1ip6xj256qy9n3wqip00s";
      };

      beamDeps = [ ash phoenix phoenix_html phoenix_live_view ];
    };

    ash_postgres = buildMix rec {
      name = "ash_postgres";
      version = "1.3.30";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1smv49mw9vkwy4y00b5dihp8d46iayqi1ik6z48g9m1j6c9gnchm";
      };

      beamDeps = [ ash ecto ecto_sql jason postgrex ];
    };

    assent = buildMix rec {
      name = "assent";
      version = "0.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0gqksiv2mkl26shbn576zc7c2mdkzicgsxfi7c02nqr0g6swb6x3";
      };

      beamDeps = [ certifi jose mint ssl_verify_fun ];
    };

    bcrypt_elixir = buildMix rec {
      name = "bcrypt_elixir";
      version = "3.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1kwnzcjf6v4af12nzw5b2fksk1m1fvbxvhclczy1wpb4zdgbjss8";
      };

      beamDeps = [ comeonin elixir_make ];
    };

    boruta = buildMix rec {
      name = "boruta";
      version = "2.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nghgfnhw9fyfwiswn1lcd9182scb42d8jynq2plg15bf0pl61mf";
      };

      beamDeps = [ ecto_sql ex_json_schema joken jose nebulex phoenix plug postgrex puid secure_random shards ];
    };

    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19bp6xh052ql3ha0v3r8999cvja5d2p6cph02mxphfaj4jsbyc53";
      };

      beamDeps = [];
    };

    castore = buildMix rec {
      name = "castore";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "02rrljx2f6zhmiwqwyk7al0gdf66qpx4jm59sqg1cnyiylgb02k8";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ha6vmf5p3xlbf5w1msa89frhvfk535rnyfybz9wdmh6vdms8v96";
      };

      beamDeps = [];
    };

    cloak = buildMix rec {
      name = "cloak";
      version = "1.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "11cmkdsncmm8c35g68mp82snmbm5kqqjw4gx60lja6ymzk25l3cl";
      };

      beamDeps = [ jason ];
    };

    cloak_ecto = buildMix rec {
      name = "cloak_ecto";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0by6l0apnm9l12pclnnrbjrhf5wvd3b8nqc6nxjgw4y8hmqngk4b";
      };

      beamDeps = [ cloak ecto ];
    };

    comeonin = buildMix rec {
      name = "comeonin";
      version = "5.3.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pw4rhhsh8mwj26dkbxz2niih9j8pc3qijlpcl8jh208rg1cjf1y";
      };

      beamDeps = [];
    };

    comparable = buildMix rec {
      name = "comparable";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "035n5vv52bn6rpa5md1hd3p1dyjjgsg1jv0wsiy6wwndn7p12z17";
      };

      beamDeps = [ typable ];
    };

    conv_case = buildMix rec {
      name = "conv_case";
      version = "0.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0jjb1lkzdpkgcx711k78qnvsn4d07pnr9qzpcnc2yx6ijwyrmwl8";
      };

      beamDeps = [];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.10.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sqxqjdykxc2ai9cvkc0xjwkvr80z98wzlqlrd1z3iiw32vwrz9s";
      };

      beamDeps = [ cowlib ranch ];
    };

    cowboy_telemetry = buildRebar3 rec {
      name = "cowboy_telemetry";
      version = "0.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1pn90is3k9dq64wbijvzkqb6ldfqvwiqi7ymc8dx6ra5xv0vm63x";
      };

      beamDeps = [ cowboy telemetry ];
    };

    cowlib = buildRebar3 rec {
      name = "cowlib";
      version = "2.12.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1c4dgi8canscyjgddp22mjc69znvwy44wk3r7jrl2wvs6vv76fqn";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mv9lyw6hgjn6hlnzfbs0x2dchvwlmj8bg0a8l7iq38z7pvgqfb8";
      };

      beamDeps = [ bunt file_system jason ];
    };

    crypto_rand = buildMix rec {
      name = "crypto_rand";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "118nvawarrkd9lg96ikhd35n0apq3ccm0bx0mrhgw68ilzz7c6kh";
      };

      beamDeps = [];
    };

    db_connection = buildMix rec {
      name = "db_connection";
      version = "2.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18jsnmabdjwj3i7ml43ljzrzzvfy1a3bnbaqywgsv7nndji5nbf9";
      };

      beamDeps = [ telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k7z418b6cj977wswpxsk5844xrxc1smaiqsmrqpf3pdjzsfbksk";
      };

      beamDeps = [];
    };

    decorator = buildMix rec {
      name = "decorator";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0zsrasbf6z3g7xs1s8gk5g7rf49ng1dskphqfif8gnl3j3fww1qa";
      };

      beamDeps = [];
    };

    earmark_parser = buildMix rec {
      name = "earmark_parser";
      version = "1.4.32";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0md7rhw1ix4fp31bql9scvl4jpijixczm2ky7mxffwq3srvxvc5q";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.10.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0d82qqlvhpi1mkqifayzzd0r0068l5csz1ml6i5qlr6py1w5g2ba";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.10.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0sy5277akp828hvcg60yxhpfgj543y2z1bqy2z414pv9ppdmp8pn";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.7.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0v3y9i3bif14486dliwn9arwd0pcp4nv24gjwnxm5b8gjpzrzhav";
      };

      beamDeps = [ castore ];
    };

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.7.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0g7i36fsnry20w15lq5jc6bval3pwv73ymqnvkj8wdxif3giqrk6";
      };

      beamDeps = [ castore ];
    };

    ets = buildMix rec {
      name = "ets";
      version = "0.8.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1k0mi6vj0z66y19qvb9zzd1a5x7i18nyl9bgc91mrg5mmm81pr3b";
      };

      beamDeps = [];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.29.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1xf49d0ni08a83iankdj8fb6jyxm67wjl0gdwihwnimf6ykrjric";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_json_schema = buildMix rec {
      name = "ex_json_schema";
      version = "0.9.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1a7him55gdrfhb3fvma28hmhqfj8vdxihmb2f00k1lzgkk8656dp";
      };

      beamDeps = [ decimal ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0iyfl4vppfhmimfqaracjza9a6y8rgia03sm28y5934cg5xbmxrg";
      };

      beamDeps = [];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1p0myxmnjjds8bbg69dd6fvhk8q3n7lb78zd4qvmjajnzgdmw6a1";
      };

      beamDeps = [];
    };

    floki = buildMix rec {
      name = "floki";
      version = "0.34.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h936kfai562dh4qpcpri7jxrdmqyxaymizk9d5r55svx8748xwm";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.22.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0q0gqcgdrksjjjqvxrqa1080crhjrhn6lziqmrz2va5fffb3hbca";
      };

      beamDeps = [ expo ];
    };

    hackney = buildRebar3 rec {
      name = "hackney";
      version = "1.18.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "13hja14kig5jnzcizpdghj68i88f0yd9wjdfjic9nzi98kzxmv54";
      };

      beamDeps = [ certifi idna metrics mimerl parse_trans ssl_verify_fun unicode_util_compat ];
    };

    hpax = buildMix rec {
      name = "hpax";
      version = "0.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04wci9ifsfyd2pbcrnpgh2aq0a8fi1lpkrzb91kz3x93b8yq91rc";
      };

      beamDeps = [];
    };

    idna = buildRebar3 rec {
      name = "idna";
      version = "6.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1sjcjibl34sprpf1dgdmzfww24xlyy34lpj7mhcys4j4i6vnwdwj";
      };

      beamDeps = [ unicode_util_compat ];
    };

    influxql = buildMix rec {
      name = "influxql";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0p1006vaz2sq5bmnvsf58586b4m03fnflsbqhah0r0ync14z1ykm";
      };

      beamDeps = [];
    };

    instream = buildMix rec {
      name = "instream";
      version = "2.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0alc066i51fkzlcbgcq92m63ys5rww70ip4kz8ld5zci9717q372";
      };

      beamDeps = [ hackney influxql jason nimble_csv poolboy ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0891p2yrg3ri04p302cxfww3fi16pvvw1kh4r91zg85jhl87k8vr";
      };

      beamDeps = [ decimal ];
    };

    joken = buildMix rec {
      name = "joken";
      version = "2.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19xanmavc4n5zzypxyi4qd93m8l7sjqswy2ksfmm82ydf5db15as";
      };

      beamDeps = [ jose ];
    };

    jose = buildMix rec {
      name = "jose";
      version = "1.11.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "115k981kfg9jmafgs16rybc5qah6p0zgvni3bdyfl0pyp8av5lyw";
      };

      beamDeps = [];
    };

    json_xema = buildMix rec {
      name = "json_xema";
      version = "0.4.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "106s3x6f79a0470cdfi7jm8pgliqf8lflqqdkrk22zb6b0vj25jm";
      };

      beamDeps = [ conv_case xema ];
    };

    makeup = buildMix rec {
      name = "makeup";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19jpprryixi452jwhws3bbks6ki3wni9kgzah3srg22a3x8fsi8a";
      };

      beamDeps = [ nimble_parsec ];
    };

    makeup_elixir = buildMix rec {
      name = "makeup_elixir";
      version = "0.16.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ik7qw0d5xyc7dv3n33qxl49jfk92l565lbv1zc9n80vmm0s69z1";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "02411riqa713wzw8in582yva6n6spi4w1ndnj8nhjvnfjg5a3xgk";
      };

      beamDeps = [ makeup ];
    };

    metrics = buildRebar3 rec {
      name = "metrics";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05lz15piphyhvvm3d1ldjyw0zsrvz50d2m5f2q3s8x2gvkfrmc39";
      };

      beamDeps = [];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0p50h0ki8ay5sraiqxiajgwy1829bvyagj65bj9wjny4cnin83fs";
      };

      beamDeps = [];
    };

    mimerl = buildRebar3 rec {
      name = "mimerl";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08wkw73dy449n68ssrkz57gikfzqk3vfnf264s31jn5aa1b5hy7j";
      };

      beamDeps = [];
    };

    mint = buildMix rec {
      name = "mint";
      version = "1.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07jvgmggmv6bxhkmrskdjz1xvv0a1l53fby7sammcfbwdbky2qsa";
      };

      beamDeps = [ castore hpax ];
    };

    mox = buildMix rec {
      name = "mox";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1wpyh6wp76lyx0q2cys23rpmci4gj1pqwnqvfk467xxanchlk1pr";
      };

      beamDeps = [];
    };

    nebulex = buildMix rec {
      name = "nebulex";
      version = "2.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1kxwhgh8i8vlrw93cmrsjssjl6f0z8szxdr9n8cyws4cv403h3cd";
      };

      beamDeps = [ decorator shards telemetry ];
    };

    nimble_csv = buildMix rec {
      name = "nimble_csv";
      version = "1.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0amij6y3pgkpazhjr3madrn9c9lv6malq11ln1w82562zhbq2qnh";
      };

      beamDeps = [];
    };

    nimble_options = buildMix rec {
      name = "nimble_options";
      version = "1.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1f7ih1rnkvph0daf4lsv4rrp6dpccksjd7rh5bhnq0r143dsh4px";
      };

      beamDeps = [];
    };

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rxiw6jzz77v0j460wmzcprhdgn71g1hrz3mcc6djn7bnb0f70i6";
      };

      beamDeps = [];
    };

    nimble_totp = buildMix rec {
      name = "nimble_totp";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1agd92zavq9fw0ix3fp64cam8rkgz0vq5cc55rwdpv7yd30f9rbc";
      };

      beamDeps = [];
    };

    oauth2 = buildMix rec {
      name = "oauth2";
      version = "2.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0h9bps7gq7bac5gc3q0cgpsj46qnchpqbv5hzsnd2z9hnf2pzh4a";
      };

      beamDeps = [ tesla ];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.17.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1zphp59dd3l4l8279pjmhbddskimbgrr123wivycz0yahldb4p8n";
      };

      beamDeps = [ jason plug ];
    };

    parse_trans = buildRebar3 rec {
      name = "parse_trans";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "12w8ai6b5s6b4hnvkav7hwxd846zdd74r32f84nkcmjzi1vrbk87";
      };

      beamDeps = [];
    };

    phoenix = buildMix rec {
      name = "phoenix";
      version = "1.7.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "127v5lrb0zflgm5cqwxsfjv76mizdldkzs66rdhb0as0h1vvxd7n";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_template phoenix_view plug plug_cowboy plug_crypto telemetry websock_adapter ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0pcgrvj5lqjmsngrhl77kv0l8ik8gg7pw19v4xlhpm818vfjw93h";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1lyhagjpg4lran6431csgkvf28g50mdvh4mlsxgs21j9vmp91ldy";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.7.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dq5vj1a6fzclr3fwj7y8rg2xq3yigvgqc3aaq664fvs7h3dypqf";
      };

      beamDeps = [ ecto mime phoenix_live_view telemetry_metrics ];
    };

    phoenix_live_reload = buildMix rec {
      name = "phoenix_live_reload";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1aqm6sxy4ijd5gi8lmjmcaxal1smg2smibjlzrkq9w6xwwsbizwv";
      };

      beamDeps = [ file_system phoenix ];
    };

    phoenix_live_view = buildMix rec {
      name = "phoenix_live_view";
      version = "0.18.18";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "052jv2kbc2nb4qs4ly4idcai6q8wyfkvv59adpg9w67kf820v0d5";
      };

      beamDeps = [ jason phoenix phoenix_html phoenix_template phoenix_view telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00p5dvizhawhqbia2cakdn4whaxsm2adq3lzfn3b137xvk0np85v";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1vlkd4z2bxinczwcysydidpnh49rpxjihb5k3k4k8qr2yrwc0z8m";
      };

      beamDeps = [ phoenix_html ];
    };

    phoenix_view = buildMix rec {
      name = "phoenix_view";
      version = "2.0.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vykabqxyk08gkfm45zy5dnlnzygwx6g9z4z2h7fxix51qiyfad9";
      };

      beamDeps = [ phoenix_html phoenix_template ];
    };

    picosat_elixir = buildMix rec {
      name = "picosat_elixir";
      version = "0.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rkcq5wapdw34f1rrncc9sc3xm83akv3bgm9z8gmdln9vsr9sv7p";
      };

      beamDeps = [ elixir_make ];
    };

    plug = buildMix rec {
      name = "plug";
      version = "1.14.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04wdyv6nma74bj1m49vkm2bc5mjf8zclfg957fng8g71hw0wabw4";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04v6xc4v741dr2y38j66fmcc4xc037dnaxzkj2vih6j53yif2dny";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "1.2.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hnqgzc3zas7j7wycgnkkdhaji5farkqccy2n4p1gqj5ccfrlm16";
      };

      beamDeps = [];
    };

    poolboy = buildRebar3 rec {
      name = "poolboy";
      version = "1.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qq116314418jp4skxg8c6jx29fwp688a738lgaz6h2lrq29gmys";
      };

      beamDeps = [];
    };

    postgrex = buildMix rec {
      name = "postgrex";
      version = "0.17.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0md5j9k1vkwwzql68in6hmj0vfcdbnav33shxszf4fz7i2s5gc0l";
      };

      beamDeps = [ db_connection decimal jason ];
    };

    puid = buildMix rec {
      name = "puid";
      version = "1.1.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1apzy5wc5xs48dzb749a3ynh4ivpav9g8liqybxw8xp554g6klgv";
      };

      beamDeps = [ crypto_rand ];
    };

    ranch = buildRebar3 rec {
      name = "ranch";
      version = "1.8.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rfz5ld54pkd2w25jadyznia2vb7aw9bclck21fizargd39wzys9";
      };

      beamDeps = [];
    };

    redoc_ui_plug = buildMix rec {
      name = "redoc_ui_plug";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0jvizv8mwhbfalilc81b90nf73bqqz6gpy0qzklqf2113yrivq3v";
      };

      beamDeps = [ jason plug ];
    };

    secure_random = buildMix rec {
      name = "secure_random";
      version = "0.5.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1az658qpha6pnlns37pn9l201wck4ahrvldgp91s2h1rbvqm95qv";
      };

      beamDeps = [];
    };

    shards = buildRebar3 rec {
      name = "shards";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ir4y5zqplk6j8ik99f5ankypkzmfhggvhh1lskmi92lb9b8w60x";
      };

      beamDeps = [];
    };

    slugger = buildMix rec {
      name = "slugger";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fmgnl4ydq4ivbfk1a934vcn0d0wb24lhnvcmqg5sq0jwz8dxl10";
      };

      beamDeps = [];
    };

    slugify = buildMix rec {
      name = "slugify";
      version = "1.3.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xmyv324a5prnzj20y1j1nkn18rki7cq3ri567d15csnn2z0n2fb";
      };

      beamDeps = [];
    };

    sourceror = buildMix rec {
      name = "sourceror";
      version = "0.12.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "05h3rsdcgb25pfmh2adqysb4mwr26ilc9zwlh5754im01h0phkjd";
      };

      beamDeps = [];
    };

    spark = buildMix rec {
      name = "spark";
      version = "1.1.18";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0rzisrlww5s71y5zafi2nc64apgjywwfb7igm089icq1ds34cjwn";
      };

      beamDeps = [ nimble_options sourceror ];
    };

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.7";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y37pj5q6gk1vrnwg1vraws9yihrv9g4133w2qq1sh1piw71jk7y";
      };

      beamDeps = [];
    };

    stream_data = buildMix rec {
      name = "stream_data";
      version = "0.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0wg2p5hwf7qmkwsc1i3q7h558f7sr9f13y8i6kds9bb9q3pd4aq1";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.11.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vkjz91jbymbxyp3z8ha6i6iqvf0qy5ay5430azxbrq32mcz8hsc";
      };

      beamDeps = [ cowboy hackney jason mime plug_cowboy telemetry ];
    };

    tailwind = buildMix rec {
      name = "tailwind";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xx2r741jzh669229nni7h4mmsz18hbj5d6iivjp6py90xhkz8g8";
      };

      beamDeps = [ castore ];
    };

    telemetry = buildRebar3 rec {
      name = "telemetry";
      version = "1.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mgyx9zw92g6w8fp9pblm3b0bghwxwwcbslrixq23ipzisfwxnfs";
      };

      beamDeps = [];
    };

    telemetry_metrics = buildMix rec {
      name = "telemetry_metrics";
      version = "0.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iilk2n75kn9i95fdp8mpxvn3rcn3ghln7p77cijqws13j3y1sbv";
      };

      beamDeps = [ telemetry ];
    };

    telemetry_metrics_telegraf = buildMix rec {
      name = "telemetry_metrics_telegraf";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ms2qncl0rc0ardap1si6lb0sgn73c34hx87pqmzv5g1vid8ix92";
      };

      beamDeps = [ telemetry_metrics ];
    };

    telemetry_poller = buildRebar3 rec {
      name = "telemetry_poller";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vjgxkxn9ll1gc6xd8jh4b0ldmg9l7fsfg7w63d44gvcssplx8mk";
      };

      beamDeps = [ telemetry ];
    };

    tesla = buildMix rec {
      name = "tesla";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04y31nq54j1wnzpi37779bzzq0sjwsh53ikvnh4n40nvpwgg0r1f";
      };

      beamDeps = [ castore hackney jason mime mint telemetry ];
    };

    typable = buildMix rec {
      name = "typable";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1y2qb2afy3hn7nl6b029dwaqck70253zjj5c132s989dfnbhf2l8";
      };

      beamDeps = [];
    };

    ueberauth = buildMix rec {
      name = "ueberauth";
      version = "0.10.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1qf97azn8064ymawfm58p2bqpmrigipr4fs5xp3jb8chshqizz9y";
      };

      beamDeps = [ plug ];
    };

    ueberauth_github = buildMix rec {
      name = "ueberauth_github";
      version = "0.8.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iiw953l4mk087r2jrpcnyqdmgv2n8cq5947f8fsbkrjkj3v42mf";
      };

      beamDeps = [ oauth2 ueberauth ];
    };

    unicode_util_compat = buildRebar3 rec {
      name = "unicode_util_compat";
      version = "0.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08952lw8cjdw8w171lv8wqbrxc4rcmb3jhkrdb7n06gngpbfdvi5";
      };

      beamDeps = [];
    };

    websock = buildMix rec {
      name = "websock";
      version = "0.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "01gzcvz86x4hxk5d50qz38nkmi1fakyn5yw0m7gi6s6a5zi5spwj";
      };

      beamDeps = [];
    };

    websock_adapter = buildMix rec {
      name = "websock_adapter";
      version = "0.5.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0g8djd6l1yq8s84y4r3938dczvjs6jgxjbdm0ah6wszqq4abirfb";
      };

      beamDeps = [ plug plug_cowboy websock ];
    };

    xema = buildMix rec {
      name = "xema";
      version = "0.17.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1gmwr2glfpk7qks7xncc0pdl9if335d77zbmb0fbm7svbk3sy84h";
      };

      beamDeps = [ conv_case decimal ];
    };
  };
in self

