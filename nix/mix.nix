{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    appsignal = buildMix rec {
      name = "appsignal";
      version = "2.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1c4cv8r09cliarnvh1i58iw7izr87avawrswkz1fdjzmxjiayikm";
      };

      beamDeps = [ decorator hackney jason telemetry ];
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
      version = "2.2.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1bixcb3rqgm23yl8llxjaapqf683fwf5my6pm7705vrf0gqjmkhs";
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
      version = "0.1.20";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "12n9bb4v9b9sx9xk11k98s4f4a532dmmn0x4ak28dj990mjvf850";
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

    chunkr = buildMix rec {
      name = "chunkr";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19z058r5xk9s48946shxgaqbx0i5215br9ij8wm9y6va6wsqlphi";
      };

      beamDeps = [ ecto_sql ];
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

    connection = buildMix rec {
      name = "connection";
      version = "1.1.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1746n8ba11amp1xhwzp38yfii2h051za8ndxlwdykyqqljq1wb3j";
      };

      beamDeps = [];
    };

    cowboy = buildErlangMk rec {
      name = "cowboy";
      version = "2.9.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1phv0a1zbgk7imfgcm0dlacm7hbjcdygb0pqmx4s26jf9f9rywic";
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
      version = "2.11.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ac6pj3x4vdbsa8hvmbzpdfc4k0v1p102jbd39snai8wnah9sgib";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.0-rc.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "10q8w67gmw90hbwal3gvlba1z3zzrc567l8vz5r2s2mxiyyi6cjj";
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
      version = "2.4.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "04iwywfqf8k125yfvm084l1mp0bcv82mwih7xlpb7kx61xdw29y1";
      };

      beamDeps = [ connection telemetry ];
    };

    decimal = buildMix rec {
      name = "decimal";
      version = "2.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xzm8hfhn8q02rmg8cpgs68n5jz61wvqg7bxww9i1a6yanf6wril";
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
      version = "1.4.29";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00rmqvf3hkxfvkijqd624n0hn1xqims8h211xmm02fdi7qdsy0j9";
      };

      beamDeps = [];
    };

    ecto = buildMix rec {
      name = "ecto";
      version = "3.9.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0xgfz1pzylj22k0qa8zh4idvd4139b1lwnmq33na8fia2j69hpyy";
      };

      beamDeps = [ decimal jason telemetry ];
    };

    ecto_autoslug_field = buildMix rec {
      name = "ecto_autoslug_field";
      version = "3.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "03ycq3c6sm79sx5cxsbv3yc1zvx0ss2a8mig0qr33wc5rz3m5hlf";
      };

      beamDeps = [ ecto slugger ];
    };

    ecto_sql = buildMix rec {
      name = "ecto_sql";
      version = "3.9.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0w1zplm8ndf10dwxffg60iwzvbz3hyyiy761x91cvnwg6nsfxd8y";
      };

      beamDeps = [ db_connection ecto postgrex telemetry ];
    };

    elixir_make = buildMix rec {
      name = "elixir_make";
      version = "0.7.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0x5jw9n6xxmiybrv0y5n2w6kvfpjbsci9ji4l0gyvnvak7is7b94";
      };

      beamDeps = [ castore ];
    };

    esbuild = buildMix rec {
      name = "esbuild";
      version = "0.5.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rgzjjb0j3m0xz8gs112dydfz7m5brlpfm2qmz7w8qyr6ars10zi";
      };

      beamDeps = [ castore ];
    };

    ex_doc = buildMix rec {
      name = "ex_doc";
      version = "0.29.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1xkljn0ggg7fk8qv2dmr2m40h3lmfhi038p2hksdldja6yk5yx5p";
      };

      beamDeps = [ earmark_parser makeup_elixir makeup_erlang ];
    };

    ex_json_schema = buildMix rec {
      name = "ex_json_schema";
      version = "0.9.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "092jllmz4kyyzbmf04za37m5pp0lpsrvz3ab9hfc1djjnff34m28";
      };

      beamDeps = [ decimal ];
    };

    expo = buildMix rec {
      name = "expo";
      version = "0.3.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "08qqi0mxgi4hz9x3qqzsy034ls7zwbd9fm4i10bbqxra06zx8g7v";
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
      version = "0.34.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1769xg2sqdh6s1j06l7gi98iy35ri79xk6sq58rh1phdyi1ryflw";
      };

      beamDeps = [];
    };

    gettext = buildMix rec {
      name = "gettext";
      version = "0.22.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1khaqywbmbnl4hkj0662v069zipjsc7lz6z4r0h3gxvn2la7a1nb";
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
      version = "2.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0hkxm2g6dkzwvvkgj8j40azbgapngfj7slwzqffj3qf11ybz7mkp";
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
      version = "0.16.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1rrqydcq2bshs577z7jbgdnrlg7cpnzc8n48kap4c2ln2gfcpci8";
      };

      beamDeps = [ makeup nimble_parsec ];
    };

    makeup_erlang = buildMix rec {
      name = "makeup_erlang";
      version = "0.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1fvw0zr7vqd94vlj62xbqh0yrih1f7wwnmlj62rz0klax44hhk8p";
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
      version = "2.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0szzdfalafpawjrrwbrplhkgxjv8837mlxbkpbn5xlj4vgq0p8r7";
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

    mox = buildMix rec {
      name = "mox";
      version = "0.5.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0aq9wvghpwxdd8xjs8rhrig3xgh7zpfm0gzr3lcfwa6niii10hyz";
      };

      beamDeps = [];
    };

    nebulex = buildMix rec {
      name = "nebulex";
      version = "2.4.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lms95b8zwpa634f6wnwa5nj259m5jhd142rr4a7dm0gfzjqiy69";
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

    nimble_parsec = buildMix rec {
      name = "nimble_parsec";
      version = "1.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1c3hnppmjkwnqrc9vvm72kpliav0mqyyk4cjp7vsqccikgiqkmy8";
      };

      beamDeps = [];
    };

    open_api_spex = buildMix rec {
      name = "open_api_spex";
      version = "3.16.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0a91jzgq6qp6ba5kxcz8fli2d1l49d8pz8dxikyfhwwbci5f42xv";
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
      version = "1.6.15";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0wh6s8id3b4c4hgiawq995p192wxsws4sr4bm1g7b55kyvxvj2np";
      };

      beamDeps = [ castore jason phoenix_pubsub phoenix_view plug plug_cowboy plug_crypto telemetry ];
    };

    phoenix_ecto = buildMix rec {
      name = "phoenix_ecto";
      version = "4.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1h9wnjmxns8y8dsr0r41ks66gscaqm7ivk4gsh5y07nkiralx1h9";
      };

      beamDeps = [ ecto phoenix_html plug ];
    };

    phoenix_html = buildMix rec {
      name = "phoenix_html";
      version = "3.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ky5idgid1psz6hmh2b2kmj6n974axww74hrxwv02p6jasx9gv1n";
      };

      beamDeps = [ plug ];
    };

    phoenix_live_dashboard = buildMix rec {
      name = "phoenix_live_dashboard";
      version = "0.6.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0lmq1m7k465i9mzw35l7bx69n85mibwzd76976840r43sw6sakzg";
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
      version = "0.17.12";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1j4r1pjl60hphan7mf0fn60cnqkdc7hah9zmf4sz8vy1mbhdavdg";
      };

      beamDeps = [ jason phoenix phoenix_html telemetry ];
    };

    phoenix_pubsub = buildMix rec {
      name = "phoenix_pubsub";
      version = "2.1.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1nfqrmbrq45if9pgk6g6vqiply2sxc40is3bfanphn7a3rnpqdl1";
      };

      beamDeps = [];
    };

    phoenix_template = buildMix rec {
      name = "phoenix_template";
      version = "1.0.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0ms39n5s6kh532s20yxzj7sh0rz5lslh09ibq5j21lkglacny1hv";
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

    plug = buildMix rec {
      name = "plug";
      version = "1.14.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "056wkb1b17mh5h9ncs2vbswvpjsm2iqc580nmyrvgznlqwr080mz";
      };

      beamDeps = [ mime plug_crypto telemetry ];
    };

    plug_cowboy = buildMix rec {
      name = "plug_cowboy";
      version = "2.6.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19jgv5dm53hv5aqgxxzr3fnrpgfll9ics199swp6iriwfl5z4g07";
      };

      beamDeps = [ cowboy cowboy_telemetry plug ];
    };

    plug_crypto = buildMix rec {
      name = "plug_crypto";
      version = "1.2.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "18plj2idhp3f0nmqyjjf2rzj849l3br0797m8ln20p5dqscj0rxm";
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
      version = "0.16.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1s5jbwfzsdsyvlwgx3bqlfwilj2c468wi3qxq0c2d23fvhwxdspd";
      };

      beamDeps = [ connection db_connection decimal jason ];
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

    ssl_verify_fun = buildRebar3 rec {
      name = "ssl_verify_fun";
      version = "1.1.6";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1026l1z1jh25z8bfrhaw0ryk5gprhrpnirq877zqhg253x3x5c5x";
      };

      beamDeps = [];
    };

    swoosh = buildMix rec {
      name = "swoosh";
      version = "1.9.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "07ipsrp34s18c9zd5kglqsdc8z7gxa9aadsrklj0zf6azzrzzpvn";
      };

      beamDeps = [ cowboy hackney jason mime plug_cowboy telemetry ];
    };

    tailwind = buildMix rec {
      name = "tailwind";
      version = "0.2.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "17iaanwxpv7z039gj4sm73gbmala6mz1h2qkwm5nbr3zrngr6piq";
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

    typed_ecto_schema = buildMix rec {
      name = "typed_ecto_schema";
      version = "0.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0fybixpflcr9rk92avycra029za0qfnwcnanvm1zanykg4prdil5";
      };

      beamDeps = [ ecto ];
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
  };
in self

