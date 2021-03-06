-- Prosody Example Configuration File
--
-- Information on configuring Prosody can be found on our
-- website at http://prosody.im/doc/configure
--
-- Tip: You can check that the syntax of this file is correct
-- when you have finished by running: luac -p prosody.cfg.lua
-- If there are any errors, it will let you know what and where
-- they are, otherwise it will keep quiet.
--
-- The only thing left to do is rename this file to remove the .dist ending, and fill in the
-- blanks. Good luck, and happy Jabbering!


---------- Server-wide settings ----------
-- Settings in this section apply to the whole server and are the default settings
-- for any virtual hosts

 -- Listen on dedicated IP address of xmpp.example.net only
 interfaces = { "192.0.2.35", "2001:db8::35" }


-- This is a (by default, empty) list of accounts that are admins
-- for the server. Note that you must create the accounts separately
-- (see http://prosody.im/doc/creating_accounts for info)
-- Example: admins = { "user1@example.net", "user2@example.net" }
admins = { "admin@example.net" }

-- Enable use of libevent for better performance under high load
-- For more information see: http://prosody.im/doc/libevent
--use_libevent = true;

-- These paths are searched in the order specified, and before the default path
plugin_paths = { "/usr/local/lib/prosody/modules" }

-- This is the list of modules Prosody will load on startup.
-- It looks for mod_modulename.lua in the plugins folder, so make sure that exists too.
-- Documentation on modules can be found at: http://prosody.im/doc/modules
modules_enabled = {

    -- Generally required
        "roster"; -- Allow users to have a roster. Recommended ;)
        "saslauth"; -- Authentication for clients and servers. Recommended if you want to log in.
        "tls"; -- Add support for secure TLS on c2s/s2s connections
        "dialback"; -- s2s dialback support
        "disco"; -- Service discovery

    -- Not essential, but recommended
        "private"; -- Private XML storage (for room bookmarks, etc.)
        "vcard"; -- Allow users to set vCards

    -- These are commented by default as they have a performance impact
        --"privacy"; -- Support privacy lists
        --"compression"; -- Stream compression (Debian: requires lua-zlib module to work)

    -- Nice to have
        "version"; -- Replies to server version requests
        "uptime"; -- Report how long server has been running
        "time"; -- Let others know the time here on this server
        "ping"; -- Replies to XMPP pings with pongs
        "pep"; -- Enables users to publish their mood, activity, playing music and more
        "register"; -- Allow users to register on this server using a client and change passwords

    -- Admin interfaces
        "admin_adhoc"; -- Allows administration via an XMPP client that supports ad-hoc commands
        --"admin_telnet"; -- Opens telnet console interface on localhost port 5582

    -- HTTP modules
        --"bosh"; -- Enable BOSH clients, aka "Jabber over HTTP"
        --"http_files"; -- Serve static files from a directory over HTTP

    -- Other specific functionality
        "posix"; -- POSIX functionality, sends server to background, enables syslog, etc.
        --"groups"; -- Shared roster support
        --"announce"; -- Send announcement to all online users
        --"welcome"; -- Welcome users who register accounts
        --"watchregistrations"; -- Alert admins of registrations
        --"motd"; -- Send a message to users when they log in
        --"legacyauth"; -- Legacy authentication. Only used by some old clients and bots.

    -- Community modules
    -- https://modules.prosody.im/
        "blocking"; -- XEP-0191: Allows the client to manage a simple list of blocked JIDs, requires "privacy" module
        "smacks"; -- XEP-0198: Reliability and fast reconnects for XMPP
        "carbons"; -- XEP-0280: Message Carbons, allows users to maintain a shared and synchronized view of all conversations across all their online clients and devices.
        "mam"; -- XEP-0313: Message Archive Management.
        "csi"; -- XEP-0352: Client State Indication
        "throttle_presence"; -- Cut down on presence traffic when clients indicate they are inactive (using the CSI protocol).
        "register_web"; -- A web interface to register user accounts.
};

-- These modules are auto-loaded, but should you want
-- to disable them then uncomment them here:
modules_disabled = {
    -- "offline"; -- Store offline messages
    -- "c2s"; -- Handle client connections
    -- "s2s"; -- Handle server-to-server connections
};

-- Register Web Template files
register_web_template = "/usr/local/lib/prosody/register-templates/Prosody-Web-Registration-Theme";

-- Disable account creation by default, for security
-- For more information see http://prosody.im/doc/creating_accounts
allow_registration = false;


-- Debian:
--   send the server to background.
--
daemonize = true;

-- Debian:
--   Please, don't change this option since /var/run/prosody/
--   is one of the few directories Prosody is allowed to write to
--
pidfile = "/var/run/prosody/prosody.pid";

-- Override the address used to connect to a given host with the address of
-- a hidden service.
Include "/usr/local/lib/prosody/xmpp-onion-map/onions-map.lua"

-- SSL/TLS-related settings.
ssl = {
    options = {
                "no_sslv2",
                "no_sslv3",
                "no_ticket",
                "no_compression",
                "cipher_server_preference",
                "single_dh_use",
                "single_ecdh_use"
              };
    ciphers = "kEDH+aRSA+AES128:kEECDH+aRSA+AES128:+SSLv3";
    dhparam = "/etc/ssl/dhparams/dh_4096.pem";
    key = "/etc/ssl/certs/example.net.key.pem";
    certificate = "/etc/ssl/certs/example.net.cert.pem";
}

-- TLS Client Encrpytion
-- Force clients to use encrypted connections? This option will
-- prevent clients from authenticating unless they are using encryption.
c2s_require_encryption = true

-- Force certificate authentication for server-to-server connections?
-- This provides ideal security, but requires servers you communicate
-- with to support encryption AND present valid, trusted certificates.
-- NOTE: Your version of LuaSec must support certificate verification!
-- For more information see http://prosody.im/doc/s2s#security

s2s_secure_auth = false

-- Many servers don't support encryption or have invalid or self-signed
-- certificates. You can list domains here that will not be required to
-- authenticate using certificates. They will be authenticated using DNS.

--s2s_insecure_domains = { "gmail.com" }

-- Even if you leave s2s_secure_auth disabled, you can still require valid
-- certificates for some domains by specifying a list here.

--s2s_secure_domains = { "jabber.org" }

-- Select the authentication backend to use. The 'internal' providers
-- use Prosody's configured data storage to store the authentication data.
-- To allow Prosody to offer secure authentication mechanisms to clients, the
-- default provider stores passwords in plaintext. If you do not trust your
-- server please see http://prosody.im/doc/modules/mod_auth_internal_hashed
-- for information about using the hashed backend.

authentication = "internal_plain"

-- Select the storage backend to use. By default Prosody uses flat files
-- in its configured data directory, but it also supports more backends
-- through modules. An "sql" backend is included by default, but requires
-- additional dependencies. See http://prosody.im/doc/storage for more info.

--storage = "sql" -- Default is "internal" (Debian: "sql" requires one of the
-- lua-dbi-sqlite3, lua-dbi-mysql or lua-dbi-postgresql packages to work)

-- For the "sql" backend, you can uncomment *one* of the below to configure:
--sql = { driver = "SQLite3", database = "prosody.sqlite" } -- Default. 'database' is the filename.
--sql = { driver = "MySQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }
--sql = { driver = "PostgreSQL", database = "prosody", username = "prosody", password = "secret", host = "localhost" }

--
-- XMPP client-to-client file transfer proxy
proxy65_interfaces { "192.0.2.35", "2001:db8::35" }
--proxy65_ports { 5000 }


-- BOSH (previously known as 'HTTP binding' or "http-bind")
bosh_ports = {
    {
        port = 5280;
        path = "http-bind";
    },
    {
        port = 5281;
        path = "http-bind";
        ssl = {
            key = "/etc/ssl/private/example.net.key.pem";
            certificate = "/etc/ssl/certs/example.net.chained.cert.pem";
        }
    }
}


-- Logging configuration
-- For advanced logging see http://prosody.im/doc/logging
--
-- Debian:
--  Logs info and higher to /var/log
--  Logs errors to syslog also
log = {
    -- Log files (change 'info' to 'debug' for debug logs):
    info = "/var/log/prosody/prosody.log";
    error = "/var/log/prosody/prosody.err";
    -- Syslog:
    { levels = { "error" }; to = "syslog";  };
}

----------- Virtual hosts -----------
-- You need to add a VirtualHost entry for each domain you wish Prosody to serve.
-- Settings under each VirtualHost entry apply *only* to that host.

VirtualHost "example.net"
    enabled = false -- Remove this line to enable this host

    -- Assign this host a certificate for TLS, otherwise it would use the one
    -- set in the global section (if any).
    -- Note that old-style SSL on port 5223 only supports one certificate, and will always
    -- use the global one.
    ssl = {
        key = "/etc/ssl/private/example.net.key.pem";
        certificate = "/etc/ssl/certs/example.net.chained.cert.pem";
    }

------ Components ------
-- You can specify components to add hosts that provide special services,
-- like multi-user conferences, and transports.
-- For more information on components, see http://prosody.im/doc/components

---Set up a MUC (multi-user chat) room server on conference.example.net:
--Component "conference.example.net" "muc"

-- Set up a SOCKS5 bytestream proxy for server-proxied file transfers:
--Component "proxy.example.net" "proxy65"

---Set up an external component (default component port is 5347)
--
-- External components allow adding various services, such as gateways/
-- transports to other networks like ICQ, MSN and Yahoo. For more info
-- see: http://prosody.im/doc/components#adding_an_external_component
--
--Component "gateway.example.net"
--  component_secret = "password"

------ Additional config files ------
-- For organizational purposes you may prefer to add VirtualHost and
-- Component definitions in their own config files. This line includes
-- all config files in /etc/prosody/conf.d/

Include "conf.d/*.cfg.lua"
