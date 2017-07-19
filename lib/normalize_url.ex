defmodule NormalizeUrl do
  @moduledoc """
  The base module of NormalizeUrl.

  It exposes a single function, normalize_url.
  """

  @doc """
  Normalizes a url. This is useful for displaying, storing, comparing, etc.

  Args:

  * `url` - the url to normalize, string

  Options:

  * `strip_www` - strip the www from the url, boolean
  * `strip_fragment` - strip the fragment from the url, boolean
  * `normalize_protocol` - prepend `http:` if the url is protocol relative, boolean

  Returns a url as a string.
  """
  def normalize_url(url, options \\ []) do
    scheme = filter_scheme(url)

    if (scheme == "http") || (scheme == "ftp") || (scheme == nil) do
      normalize_http_or_ftp_url(url, options)
    else
      url
    end
  end

  # Extracts the scheme from a URL, returning nil if it's not an accepted scheme.
  # Needed because URI.parse("example.com:4000") will return "example.com" as the scheme.
  defp filter_scheme(url) do
    %{scheme: scheme} = URI.parse(url)

    if Enum.any?(accepted_schemes, &(&1 == scheme)), do: scheme, else: nil
  end

  defp accepted_schemes do
    iana_schemes ++ ["javascript"]
  end

  defp normalize_http_or_ftp_url(url, options \\ []) do
    options = Keyword.merge([
      normalize_protocol: true,
      strip_www: true,
      strip_fragment: true,
      add_root_path: false
    ], options)

    scheme = ""
    url = if Regex.match?(~r/^\/\//, url), do: "http:" <> url, else: url

    if options[:normalize_protocol] do
      scheme = if Regex.match?(~r/^ftp:\/\//, url), do: "ftp://", else: "http://"
    else
      scheme = "//"
    end

    if options[:normalize_protocol] && !Regex.match?(~r/^(http|ftp:\/\/)/, url) do
      url = "http://" <> url
    end

    uri = if options[:downcase] do
      URI.parse(String.downcase(url))
    else
      URI.parse(url)
    end

    port = if options[:normalize_protocol] && uri.port, do: ":" <> Integer.to_string(uri.port), else: ""
    if uri.port == 8080 || uri.port == 443 do
      port = ""
      scheme = "https://"
    end

    if uri.port == 21 && scheme == "ftp://" do
      port = ""
    end

    if options[:normalize_protocol] && uri.port == 80 do
      port = ""
      scheme = "http://"
    end

    path = uri.path
    if options[:add_root_path] && is_nil(path) do
      path = "/"
    end

    host_and_path = if path, do: uri.host <> port <> path, else: uri.host <> port

    if !options[:strip_fragment] && uri.fragment do
      host_and_path = host_and_path <> "#" <> uri.fragment
    end

    if options[:strip_www] do
      host_and_path = Regex.replace(~r/^www\./, host_and_path, "")
    end

    query_params = ""
    if uri.query do
      sorted_query_params = uri.query |> URI.decode_query |> URI.encode_query
      query_params = "?" <> sorted_query_params
    end

    scheme <> host_and_path <> query_params
  end

  # Taken from https://www.iana.org/assignments/uri-schemes/uri-schemes.txt
  defp iana_schemes do
    """
    aaa
    aaas
    about
    acap
    acct
    acr
    adiumxtra
    afp
    afs
    aim
    appdata
    apt
    attachment
    aw
    barion
    beshare
    bitcoin
    blob
    bolo
    browserext
    callto
    cap
    chrome
    chrome-extension
    cid
    coap
    coap+tcp
    coaps
    coaps+tcp
    com-eventbrite-attendee
    content
    crid
    cvs
    data
    dav
    dict
    dis
    dlna-playcontainer
    dlna-playsingle
    dns
    dntp
    dtn
    dvb
    ed2k
    example
    facetime
    fax
    feed
    feedready
    file
    filesystem
    finger
    fish
    ftp
    geo
    gg
    git
    gizmoproject
    go
    gopher
    graph
    gtalk
    h323
    ham
    hcp
    http
    https
    hxxp
    hxxps
    hydrazone
    iax
    icap
    icon
    im
    imap
    info
    iotdisco
    ipn
    ipp
    ipps
    irc
    irc6
    ircs
    iris
    iris.beep
    iris.lwz
    iris.xpc
    iris.xpcs
    isostore
    itms
    jabber
    jar
    jms
    keyparc
    lastfm
    ldap
    ldaps
    lvlt
    magnet
    mailserver
    mailto
    maps
    market
    message
    mid
    mms
    modem
    mongodb
    moz
    ms-access
    ms-browser-extension
    ms-drive-to
    ms-enrollment
    ms-excel
    ms-gamebarservices
    ms-getoffice
    ms-help
    ms-infopath
    ms-inputapp
    ms-media-stream-id
    ms-officeapp
    ms-people
    ms-project
    ms-powerpoint
    ms-publisher
    ms-search-repair
    ms-secondary-screen-contr
    ms-secondary-screen-setup
    ms-settings
    ms-settings-airplanemode
    ms-settings-bluetooth
    ms-settings-camera
    ms-settings-cellular
    ms-settings-cloudstorage
    ms-settings-connectablede
    ms-settings-displays-topo
    ms-settings-emailandaccou
    ms-settings-language
    ms-settings-location
    ms-settings-lock
    ms-settings-nfctransactio
    ms-settings-notifications
    ms-settings-power
    ms-settings-privacy
    ms-settings-proximity
    ms-settings-screenrotatio
    ms-settings-wifi
    ms-settings-workplace
    ms-spd
    ms-sttoverlay
    ms-transit-to
    ms-virtualtouchpad
    ms-visio
    ms-walk-to
    ms-whiteboard
    ms-whiteboard-cmd
    ms-word
    msnim
    msrp
    msrps
    mtqp
    mumble
    mupdate
    mvn
    news
    nfs
    ni
    nih
    nntp
    notes
    ocf
    oid
    onenote
    onenote-cmd
    opaquelocktoken
    pack
    palm
    paparazzi
    pkcs11
    platform
    pop
    pres
    prospero
    proxy
    pwid
    psyc
    qb
    query
    redis
    rediss
    reload
    res
    resource
    rmi
    rsync
    rtmfp
    rtmp
    rtsp
    rtsps
    rtspu
    secondlife
    service
    session
    sftp
    sgn
    shttp
    sieve
    sip
    sips
    skype
    smb
    sms
    smtp
    snews
    snmp
    soap.beep
    soap.beeps
    soldat
    spotify
    ssh
    steam
    stun
    stuns
    submit
    svn
    tag
    teamspeak
    tel
    teliaeid
    telnet
    tftp
    things
    thismessage
    tip
    tn3270
    tool
    turn
    turns
    tv
    udp
    unreal
    urn
    ut2004
    v-event
    vemmi
    ventrilo
    videotex
    vnc
    view-source
    wais
    webcal
    wpid
    ws
    wss
    wtai
    wyciwyg
    xcon
    xcon-userid
    xfire
    xmlrpc.beep
    xmlrpc.beeps
    xmpp
    xri
    ymsgr
    z39.50
    z39.50r
    z39.50s
    """ |> String.split(~r/\n/, trim: true)
  end

end
