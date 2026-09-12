<?xml version="1.0" encoding="UTF-8"?>
<!--
  Browsers do not render RSS. Without this stylesheet, opening /feed.xml
  shows a wall of raw XML, which reads as a broken page. This transforms the
  same feed into a readable page for humans; feed readers ignore it entirely.
-->
<xsl:stylesheet version="1.0"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
  xmlns:atom="http://www.w3.org/2005/Atom"
  exclude-result-prefixes="atom">

  <xsl:output method="html" encoding="UTF-8" indent="yes"/>

  <xsl:template match="/">
    <xsl:variable name="feedUrl" select="/rss/channel/atom:link[@rel='self']/@href"/>
    <html lang="en">
      <head>
        <meta charset="UTF-8"/>
        <meta name="viewport" content="width=device-width, initial-scale=1"/>
        <title><xsl:value-of select="/rss/channel/title"/> &#183; RSS feed</title>
        <link rel="icon" href="/favicon-32.png" sizes="32x32"/>
        <link rel="preconnect" href="https://fonts.googleapis.com"/>
        <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin="crossorigin"/>
        <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,400;0,9..144,500;0,9..144,600;1,9..144,500;1,9..144,600&amp;family=IBM+Plex+Mono:wght@400;500;600&amp;family=IBM+Plex+Sans:wght@400;500;600;700&amp;display=swap"/>
        <style>
          :root{
            --bg:#faf8f4; --surface:#ffffff; --ink:#1e2a33; --muted:#5c6770;
            --body-text:#3d4750; --line:rgba(30,42,51,0.10); --line-strong:rgba(30,42,51,0.18);
            --accent-text:#1f3b57; --accent-soft:rgba(31,59,87,0.07);
            --gold-text:#8a611f; --gold-soft:rgba(184,134,59,0.12);
            --serif:'Fraunces', Georgia, serif;
            --mono:'IBM Plex Mono', ui-monospace, monospace;
            --sans:'IBM Plex Sans', system-ui, sans-serif;
          }
          :root[data-theme="dark"]{
            --bg:#15171a; --surface:#1c1f23; --ink:#eef0f2; --muted:#9aa4ac;
            --body-text:#c9ced3; --line:rgba(255,255,255,0.10); --line-strong:rgba(255,255,255,0.18);
            --accent-text:#7fb0e6; --accent-soft:rgba(127,176,230,0.16);
            --gold-text:#e6bd76; --gold-soft:rgba(230,189,118,0.18);
          }
          *{ box-sizing:border-box; }
          body{
            margin:0; background:var(--bg); color:var(--ink);
            font-family:var(--sans); line-height:1.65; -webkit-font-smoothing:antialiased;
          }
          .wrap{ max-width:720px; margin:0 auto; padding:56px 24px 80px; }
          .eyebrow{
            font-family:var(--mono); font-size:12px; letter-spacing:.14em; text-transform:uppercase;
            color:var(--gold-text); margin:0 0 14px; display:block;
          }
          h1{ font-family:var(--serif); font-weight:600; font-size:clamp(28px,4vw,38px); margin:0 0 14px; line-height:1.2; }
          .tagline{ color:var(--body-text); margin:0; max-width:58ch; }

          .subscribe{
            margin:36px 0 52px; padding:22px 24px;
            background:var(--surface); border:1px solid var(--line);
            border-radius:14px;
          }
          .subscribe p{ margin:0 0 14px; font-size:14.5px; color:var(--body-text); }
          .urlrow{ display:flex; flex-wrap:wrap; gap:10px; align-items:stretch; }
          .urlrow code{
            flex:1 1 260px; min-width:0; overflow-x:auto; white-space:nowrap;
            font-family:var(--mono); font-size:13px; color:var(--accent-text);
            background:var(--accent-soft); border:1px solid var(--line);
            border-radius:8px; padding:10px 12px;
          }
          .urlrow button{
            font-family:var(--mono); font-size:11.5px; letter-spacing:.05em; text-transform:uppercase;
            color:var(--ink); background:transparent; border:1px solid var(--line-strong);
            border-radius:8px; padding:10px 16px; cursor:pointer;
          }
          .urlrow button:hover{ background:var(--accent-soft); }
          a:focus-visible, button:focus-visible{ outline:2px solid var(--accent-text); outline-offset:3px; border-radius:2px; }

          .count{
            font-family:var(--mono); font-size:11.5px; letter-spacing:.1em; text-transform:uppercase;
            color:var(--muted); margin:0 0 8px; display:block;
          }
          .item{ padding:26px 0; border-top:1px solid var(--line); }
          .item time{ font-family:var(--mono); font-size:11.5px; letter-spacing:.08em; text-transform:uppercase; color:var(--muted); }
          .item h2{ font-family:var(--serif); font-weight:600; font-size:21px; line-height:1.35; margin:8px 0 8px; }
          .item h2 a{ color:var(--ink); text-decoration:none; }
          .item h2 a:hover{ color:var(--accent-text); }
          .item p{ margin:0; color:var(--body-text); font-size:15px; max-width:62ch; }

          .back{ margin-top:44px; padding-top:26px; border-top:1px solid var(--line); }
          .back a{
            font-family:var(--mono); font-size:12px; letter-spacing:.05em;
            color:var(--accent-text); text-decoration:none;
          }
          .back a:hover{ text-decoration:underline; }
        </style>
      </head>
      <body>
        <div class="wrap">
          <span class="eyebrow">RSS feed</span>
          <h1><xsl:value-of select="/rss/channel/title"/></h1>
          <p class="tagline"><xsl:value-of select="/rss/channel/description"/></p>

          <div class="subscribe">
            <p>This page is a live RSS feed. Paste the address below into any feed reader to get new posts as they go up.</p>
            <div class="urlrow">
              <code id="feedurl"><xsl:value-of select="$feedUrl"/></code>
              <button type="button" id="copybtn">Copy</button>
            </div>
          </div>

          <span class="count"><xsl:value-of select="count(/rss/channel/item)"/> posts</span>
          <xsl:for-each select="/rss/channel/item">
            <div class="item">
              <time><xsl:value-of select="substring(pubDate, 6, 11)"/></time>
              <h2>
                <a href="{link}"><xsl:value-of select="title"/></a>
              </h2>
              <p><xsl:value-of select="description"/></p>
            </div>
          </xsl:for-each>

          <div class="back">
            <a href="{/rss/channel/link}">Read on the site &#8594;</a>
          </div>
        </div>
        <script>
          try{
            var t = localStorage.getItem('theme');
            if(t){ document.documentElement.setAttribute('data-theme', t); }
          }catch(e){}
          var btn = document.getElementById('copybtn');
          if(btn){
            btn.addEventListener('click', function(){
              var url = document.getElementById('feedurl').textContent;
              var done = function(){
                btn.textContent = 'Copied';
                setTimeout(function(){ btn.textContent = 'Copy'; }, 1600);
              };
              if(navigator.clipboard){ navigator.clipboard.writeText(url).then(done, function(){}); }
              else { done(); }
            });
          }
        </script>
      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
