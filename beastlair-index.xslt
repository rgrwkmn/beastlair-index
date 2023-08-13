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
                <title></title>

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
                        margin: 3.5rem;
                        padding: 0;
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
                        line-height: 1.7;
                        opacity: 1;
                        overflow: hidden;
                        text-overflow: ellipsis;
                        transition: color 100ms,opacity 100ms;
                        white-space: nowrap
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

                    .asset-mark {
                        position: relative;
                        background-color: transparent;
                        color: var(--theme-link-highlight);
                        display: inline-block
                    }

                    .asset-mark::before {
                        position: absolute;
                        top: 50%;
                        right: 0;
                        left: 0;
                        background-color: var(--theme-link-highlight);
                        border-radius: 1px;
                        content: "";
                        transform: translateY(-50%) translateY(0.5em);
                        width: auto;
                        height: 2px
                    }

                    .asset-item--filtered>.asset-link {
                        opacity: .4
                    }

                    .asset-item--filtered>.asset-link:focus,.asset-item--filtered>.asset-link:hover {
                        opacity: 1
                    }

                    .index-ui {
                        grid-template-areas:
                            "h h h"
                            "l d d"
                            "l d d";
                        height: 100vh;
                        width: 100vw;
                        min-width: 900px;
                    }

                    .index-ui > header {
                        grid-area: h;
                        height: 3.5rem;
                    }

                    .index-ui > .asset-list {
                        grid-area: l;
                        overflow: scroll;
                        height: calc(100vh - 3.5rem);
                    }
                    .index-ui > .asset-detail {
                        grid-area: d;
                        overflow: scroll;
                        height: calc(100vh - 3.5rem);
                    }
                </style>
            </head>
            <body>
                <div class="index-ui">
                    <header>
                        <span id="searchTextEl">Type to Search</span>
                    </header>
                    <ol aria-label="asset list" is="asset-list" class="asset-list">
                        <xsl:for-each select="list/*">
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
                        </xsl:for-each>
                    </ol>
                    <ul class="asset-detail">
                    </ul>
                </div>

<xsl:variable name="s1">
  <![CDATA[
const CustomElement = ParentClass=>class CustomElement extends ParentClass {
    static define() {
        customElements.define(this.tagName, this, {
            extends: this.tagType
        })
    }
    connectedCallback() {
        if (this.isConnected && this.mount instanceof Function) {
            this.mount()
        }
    }
    getCustomElement(customElement) {
        return this.querySelector(`[is="${customElement.tagName}"]`)
    }
};
class AssetLink extends (CustomElement(HTMLAnchorElement)) {
    static tagName = "asset-link";
    static tagType = "a";
    highlighted = false;
    highlight(searchText) {
        const regExp = new RegExp(`^(${searchText})`,"iu");
        this.highlighted = searchText !== "" && regExp.test(this.name);
        if (this.highlighted) {
            const template = '<mark class="asset-mark">$1</mark>';
            this.innerHTML = this.name.replace(regExp, template)
        } else {
            this.textContent = this.name
        }
        this.classList.toggle("asset-link--highlighted", this.highlighted)
    }
    get name() {
        return this.dataset.name
    }
    get type() {
        if (this.classList.contains("asset-link--directory")) {
            return "directory"
        }
        if (this.classList.contains("asset-link--file")) {
            return "file"
        }
        return ""
    }
}
class AssetItem extends (CustomElement(HTMLLIElement)) {
    static tagName = "asset-item";
    static tagType = "li";
    link = this.getCustomElement(AssetLink);
    highlight(searchText) {
        this.link.highlight(searchText);
        const filtered = searchText === "" || this.link.highlighted;
        this.ariaHidden = filtered ? null : true;
        this.classList.toggle("asset-item--filtered", !filtered)
    }
    get highlighted() {
        return this.link.highlighted
    }
    focus() {
        this.link.focus()
    }
}
class AssetList extends (CustomElement(HTMLOListElement)) {
    static tagName = "asset-list";
    static tagType = "ol";
    keystroke = this.keystroke.bind(this);
    searchTextEl = null;
    searchText = '';
    originalSearchText = '';
    scrollAnim = null;
    highlight() {
        let firstHighlightedAssetItem;
        for (const assetItem of this.children) {
            if (!(assetItem instanceof AssetItem)) continue;
            requestAnimationFrame(() => {
                assetItem.highlight(this.searchText);
            });
            if (firstHighlightedAssetItem === undefined && assetItem.highlighted) {
                firstHighlightedAssetItem = assetItem
            }
        }
        if (firstHighlightedAssetItem) {
            cancelAnimationFrame(this.scrollAnim);
            this.scrollAnim = requestAnimationFrame(() => {
                firstHighlightedAssetItem.focus();
                firstHighlightedAssetItem.scrollIntoView({
                    behavior: "smooth",
                    block: "nearest"
                });
            });
        }
    }
    mount() {
        this.searchTextEl = document.getElementById('searchTextEl');
        this.originalSearchText = this.searchTextEl.innerText;
        document.body.addEventListener("keyup", this.keystroke);
    }
    keystroke({key: key}) {
        console.log('key', key);
        if (key === "Escape") {
            this.searchText = '';
        } else if (key === "Backspace" && this.searchText.length > 0) {
            this.searchText = this.searchText.slice(0, -1);
        } else if (key.length === 1) {
            this.searchText += key.toLocaleLowerCase();
        }
        requestAnimationFrame(() => {
            if (this.searchText === '') {
                this.searchTextEl.innerText = this.originalSearchText;
            } else {
                this.searchTextEl.innerText = this.searchText;
            }
        });
        this.highlight();
    }
}
function main() {
    AssetLink.define();
    AssetItem.define();
    AssetList.define()
}
document.addEventListener("DOMContentLoaded", main);
  ]]>
</xsl:variable>

<script type="text/javascript">
  <xsl:text disable-output-escaping="yes">
    /* &lt;![CDATA[ */
  </xsl:text>
  <xsl:value-of select="$s1" disable-output-escaping="yes"/>
  <xsl:text disable-output-escaping="yes">
    /* ]]&gt; */
  </xsl:text>
</script>

            </body>
        </html>
    </xsl:template>
</xsl:stylesheet>
