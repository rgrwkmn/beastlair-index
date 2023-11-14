<?xml version="1.0" encoding="UTF-8" ?>

<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output method="html" encoding="UTF-8" />

  <xsl:param name="color-base00" />
  <xsl:param name="color-base07" />
  <xsl:param name="color-base0D" />
  <xsl:param name="color-base0E" />

  <xsl:variable name="custom-colors">
  <xsl:if test="$color-base00 != ''">
    <xsl:text>--color-base00: </xsl:text>
    <xsl:value-of select="$color-base00" />
    <xsl:text>;</xsl:text>
  </xsl:if>

  <xsl:if test="$color-base07 != ''">
    <xsl:text>--color-base07: </xsl:text>
    <xsl:value-of select="$color-base07" />
    <xsl:text>;</xsl:text>
  </xsl:if>

  <xsl:if test="$color-base0D != ''">
    <xsl:text>--color-base0D: </xsl:text>
    <xsl:value-of select="$color-base0D" />
    <xsl:text>;</xsl:text>
  </xsl:if>

  <xsl:if test="$color-base0E != ''">
    <xsl:text>--color-base0E: </xsl:text>
    <xsl:value-of select="$color-base0E" />
    <xsl:text>;</xsl:text>
  </xsl:if>
  </xsl:variable>

  <xsl:template match="/">
    <xsl:text disable-output-escaping="yes">&lt;!DOCTYPE html&gt;</xsl:text>

    <html>
      <head>
        <title>Beast Lair</title>

        <meta name="version" content="2.0.1" />
        <meta name="viewport" content="initial-scale=1, shrink-to-fit=no, viewport-fit=cover, width=device-width, height=device-height" />

        <style>
          :root {
          <xsl:choose>
            <xsl:when test="normalize-space($custom-colors) != ''">
              <xsl:text>:root {</xsl:text>
                <xsl:value-of select="$custom-colors" />
              <xsl:text>}</xsl:text>
            </xsl:when>
            <xsl:otherwise>
                --color-base00: #FFFFFF;
                --color-base07: #202020;
                --color-base0D: #3777E6;
                --color-base0E: #AD00A1;
            </xsl:otherwise>
          </xsl:choose>
            --theme-text: var(--color-base07);
            --theme-background: var(--color-base00);
            --theme-link-directory: var(--color-base0D);
            --theme-link-file: var(--color-base07);
            --theme-link-highlight: var(--color-base0E);
            --theme-link-hover: var(--color-base0E)
          }

          @media(prefers-color-scheme: dark) {
            :root {
              --color-base00: #2D2D2D;
              --color-base07: #F2F0EC;
              --color-base0D: #6699CC;
              --color-base0E: #CC99CC
            }
          }

          * {
            box-sizing: border-box
          }

          body {
            padding: 0;
            margin: 0;
          }

          html {
            background-color: var(--theme-background);
            font-family: SFMono-Regular,Menlo,Monaco,Consolas,"Liberation Mono","Courier New",monospace;
            font-size: 100%;
            color: var(--theme-text);
            margin: 0;
            padding: 0;
          }

          .asset-list {
            display: inline-block;
            list-style: none;
            padding: 1.75rem;
          }

          .asset-item {
            display: block
          }

          .asset-item--directory {
            color: var(--theme-link-directory)
          }

          .asset-item--file {
            color: var(--theme-link-file)
          }

          .asset-item--directory+.asset-item--file {
            margin-top: 1rem
          }

          .asset-link {
            display: block;
          }

          .asset-link:any-link {
            color: inherit;
          }

          .asset-link:focus,.asset-link:hover {
            color: var(--theme-link-hover)
          }

          .asset-link:focus {
            outline: none
          }
        </style>
      </head>
      <body>
        <div class="index-ui">
          <ol class="asset-list">
            <xsl:for-each select="list/*">
              <xsl:choose>
                <xsl:when test="name() = 'directory'">
                  <li is="asset-item">
                    <xsl:attribute name="class">
                      <xsl:text>asset-item asset-item--</xsl:text>
                      <xsl:value-of select="name()" />
                    </xsl:attribute>

                    <a is="asset-link">
                      <xsl:attribute name="aria-label">
                        <xsl:value-of select="name()" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="." />
                      </xsl:attribute>

                      <xsl:attribute name="data-name">
                        <xsl:value-of select="." />
                      </xsl:attribute>

                      <xsl:attribute name="href">
                        <xsl:value-of select="." />
                        <xsl:if test="name() = 'directory'">
                          <xsl:text>/</xsl:text>
                        </xsl:if>
                      </xsl:attribute>

                      <xsl:attribute name="class">
                        <xsl:text>asset-link asset-link--</xsl:text>
                        <xsl:value-of select="name()" />
                      </xsl:attribute>

                      <xsl:value-of select="." />
                    </a>
                  </li>
                </xsl:when>
                <xsl:when test="substring-after(., '.') = 'jpg'">
                  <li is="asset-item">
                    <xsl:attribute name="class">
                      <xsl:text>asset-item asset-item--</xsl:text>
                      <xsl:value-of select="name()" />
                    </xsl:attribute>

                    <a is="asset-link">
                      <xsl:attribute name="aria-label">
                        <xsl:value-of select="name()" />
                        <xsl:text> </xsl:text>
                        <xsl:value-of select="." />
                      </xsl:attribute>

                      <xsl:attribute name="data-name">
                        <xsl:value-of select="." />
                      </xsl:attribute>

                      <xsl:attribute name="href">
                        <xsl:value-of select="." />
                        <xsl:if test="name() = 'directory'">
                          <xsl:text>/</xsl:text>
                        </xsl:if>
                      </xsl:attribute>

                      <xsl:attribute name="class">
                        <xsl:text>asset-link asset-link--</xsl:text>
                        <xsl:value-of select="name()" />
                      </xsl:attribute>

                      <xsl:value-of select="." />

                      <img loading="lazy">
                        <xsl:attribute name="src">
                          <xsl:value-of select="." />
                        </xsl:attribute>
                      </img>
                    </a>
                  </li>
                </xsl:when>
              </xsl:choose>
            </xsl:for-each>
          </ol>
        </div>

      </body>
    </html>
  </xsl:template>
</xsl:stylesheet>
