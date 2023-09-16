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

                    /* completely hide filtered asset links */
                    .asset-item--filtered {
                        display: none;
                    }
                    .asset-item--show-filtered > .asset-item--filtered {
                        display: block;
                    }

                    .asset-item--filtered > .asset-link {
                        opacity: .4
                    }

                    .asset-item--filtered>.asset-link:focus,.asset-item--filtered>.asset-link:hover {
                        opacity: 1
                    }

                    .index-ui {
                        display: grid;
                        grid-template-areas:
                            "h h h"
                            "l d d"
                            "l d d";
                        grid-template-columns: auto, 1fr, 1fr;
                        min-width: 900px;
                    }

                    .index-ui > header {
                        grid-area: h;
                        display: flex;
                        align-items: center;
                        height: 3.5rem;
                        padding: 0 1.75rem;
                    }

                    .index-ui > header > * {
                        margin-right: 1rem;
                    }

                    .index-ui > .asset-list {
                        grid-area: l;
                        overflow: scroll;
                        height: calc(100vh - 3.5rem);
                        margin: 0;
                    }
                    .index-ui > .asset-detail {
                        grid-area: d;
                        overflow: scroll;
                        height: calc(100vh - 3.5rem);
                        margin: 0;
                        list-style: none;
                        padding: 0;
                    }
                    .asset-detail > li {
                        padding: 0;
                        display: inline-block;
                        position: relative;
                    }
                    .asset-detail > li {
                        max-height: calc(100% - 3rem);
                        max-width: calc(100% - 3rem);
                        min-height: calc(100% - 3rem);
                        min-width: calc(100% - 3rem);
                        margin: 0 1.75rem;
                    }
                    .asset-detail > li > img {
                        max-height: 100%;
                        max-width: 100%;
                    }
                    .asset-detail > li.selected .select-button {
                        background-color: orange;
                    }
                    .asset-detail.half-view > li {
                        max-height: calc(50% - 4rem);
                        max-width: calc(50% - 4rem);
                        min-height: calc(50% - 4rem);
                        min-width: calc(50% - 4rem);
                        margin: 0 1rem;
                    }
                    .asset-detail.thirds-view > li {
                        max-height: calc(33% - 3rem);
                        max-width: calc(33% - 3rem);
                        min-height: calc(33% - 3rem);
                        min-width: calc(33% - 3rem);
                        margin: 0 0.5rem;
                    }
                    .detail-info-and-actions {
                        display: flex;
                        align-items: center;
                    }
                </style>
            </head>
            <body>
                <div class="index-ui">
                    <header>
                        <input id="filterInput" is="filter-input" type="text" placeholder="filter list" />
                        <label>
                            <input id="filteredToggle" type="checkbox" /> Show Filtered
                        </label>
                        <button id="viewAllButton">View All</button>
                        <fieldset id="detailLayout">
                            <legend>Detail Layout</legend>
                            <label><input type="radio" name="layout" value="full" checked="true"/>Full</label>
                            <label><input type="radio" name="layout" value="half" />Half</label>
                            <label><input type="radio" name="layout" value="thirds" />Thirds</label>
                        </fieldset>
                        <fieldset>
                            <legend>Selection</legend>
                            <button id="selectAllButton">Select All</button>
                            <button id="selectNoneButton">Select None</button>
                            <input id="selectedItemsList" type="text" />
                        </fieldset>
                    </header>
                    <ol id="assetList" aria-label="asset list" is="asset-list" class="asset-list">
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
                    <ul id="assetDetailList" is="asset-detail-list" class="asset-detail">
                    </ul>
                </div>

<xsl:variable name="s1">
<script type="text/javascript">
  <![CDATA[
function getPngInfo(href) {
    return new Promise((resolve, reject) => {
        fetch(href).then((response, err) => {
            return response.blob();
        }).then((blob) => {
            console.log(blob);
            const fileReader = new FileReader();

            // Set up the onload event for the FileReader
            fileReader.onload = function (event) {
                // Get the PNG data as a Uint8Array
                const pngData = new Uint8Array(event.target.result);
                const dataView = new DataView(pngData.buffer);

                // Check that the PNG signature is present
                if (dataView.getUint32(0) !== 0x89504e47) {
                    reject(new Error('Not a valid PNG file'));
                    return;
                }

                // Start searching for chunks after the PNG signature
                let offset = 8;
                let txt_chunks = {};
                // Loop through the chunks in the PNG file
                while (offset < pngData.length) {
                    // Get the length of the chunk
                    const length = dataView.getUint32(offset);
                    // Get the chunk type
                    const type = String.fromCharCode(...pngData.slice(offset + 4, offset + 8));
                    if (type === "tEXt") {
                        // Get the keyword
                        let keyword_end = offset + 8;
                        while (pngData[keyword_end] !== 0) {
                            keyword_end++;
                        }
                        const keyword = String.fromCharCode(...pngData.slice(offset + 8, keyword_end));
                        // Get the text
                        const contentArraySegment = pngData.slice(keyword_end + 1, offset + 8 + length);
                        const contentJson = Array.from(contentArraySegment).map(s=>String.fromCharCode(s)).join('')
                        txt_chunks[keyword] = JSON.parse(contentJson);
                    }

                    offset += 12 + length;
                }
                resolve(txt_chunks);
            };

            fileReader.readAsArrayBuffer(blob);
        });
    })
}

// Function to parse PNG chunks and extract tEXt metadata
function parsePNGForTextChunks(pngData) {
  const textChunks = [];
  let offset = 8; // Skip the PNG header

  while (offset < pngData.length) {
    const length = readUInt32BE(pngData, offset);
    const type = readASCII(pngData, offset + 4, 4);

    if (type === 'tEXt') {
      const chunkData = pngData.subarray(offset + 8, offset + 8 + length);
      const nullTerminatorIndex = chunkData.indexOf(0);
      const keyword = chunkData.subarray(0, nullTerminatorIndex);
      const text = chunkData.subarray(nullTerminatorIndex + 1);
      textChunks.push({
        keyword: new TextDecoder().decode(keyword),
        text: new TextDecoder().decode(text),
      });
    }

    offset += length + 12; // Chunk length + Chunk type + CRC
  }

  return textChunks;
}

// Utility function to read a 4-byte unsigned integer (big-endian)
function readUInt32BE(buffer, offset) {
  return (buffer[offset] << 24) | (buffer[offset + 1] << 16) | (buffer[offset + 2] << 8) | buffer[offset + 3];
}

// Utility function to read ASCII characters from a buffer
function readASCII(buffer, offset, length) {
  return String.fromCharCode.apply(null, buffer.subarray(offset, offset + length));
}

const pngInfoDialog = document.createElement('dialog');
pngInfoDialog.innerHTML = `
  <form>
    <h2>pnginfo</h2>
    <div id="dialogComfyPrompt"></div>
    <div>
      <button value="cancel" formmethod="dialog">Close</button>
    </div>
  </form>
`;
document.body.appendChild(pngInfoDialog);
const fullPrompt = document.getElementById('dialogComfyPrompt');

const imgEnding = /(\.png|\.jpg|\.jpeg|\.webp|\.gif)$/;
const assetDetailListEl = document.getElementById('assetDetailList');
const assetListEl = document.getElementById('assetList');

const CustomElement = ParentClass=>class CustomElement extends ParentClass {
    static define() {
        customElements.define(this.tagName, this, {
            extends: this.tagType
        })
    }
    connectedCallback() {
        if (this.isConnected && this.onMount instanceof Function) {
            this.onMount()
        }
    }
    getCustomElement(customElement) {
        return this.querySelector(`[is="${customElement.tagName}"]`)
    }
};

class FilterInput extends(CustomElement(HTMLInputElement)) {
    static tagName = 'filter-input';
    static tagType = 'input';
    onMount() {
        const storageFilterText = localStorage.getItem('filterText');
        if (storageFilterText) {
            this.value = storageFilterText;
            assetListEl.setFilterText(this.value)
        }
        this.addEventListener('keyup', () => {
            assetListEl.setFilterText(this.value)
        });
        this.focus();
    }
}

class AssetDetailList extends(CustomElement(HTMLUListElement)) {
    static tagName = 'asset-detail-list';
    static tagType = 'ul';
    selectedItemsList = null;
    selectedItems = [];
    onMount() {
        document.getElementById('detailLayout').addEventListener('change', this.handleLayoutEvent.bind(this));
        document.getElementById('selectAllButton').addEventListener('click', this.handleSelectAll.bind(this));
        document.getElementById('selectNoneButton').addEventListener('click', this.handleSelectNone.bind(this));

        this.selectedItemsList = document.getElementById('selectedItemsList');
        const view = localStorage.getItem('detailLayout');
        this.handleLayout(view);
        for (const radio of document.querySelectorAll(`input[name=layout]`)) {
            console.log(radio.value, view);
            if (radio.value === view) {
                radio.checked = true;
            } else {
                radio.checked = false;
            }
        }
    }
    handleLayoutEvent(event) {
        this.handleLayout(event.target.value);
    }
    handleLayout(value) {
        switch(value) {
        case 'thirds':
            this.classList.remove('half-view');
            this.classList.add('thirds-view');
            localStorage.setItem('detailLayout', 'thirds');
            break;
        case 'half':
            this.classList.add('half-view');
            this.classList.remove('thirds-view');
            localStorage.setItem('detailLayout', 'half');
            break;
        default:
            this.classList.remove('half-view');
            this.classList.remove('thirds-view');
            localStorage.setItem('detailLayout', 'full');
        }
    }
    addItemFromLink(item) {
        this.appendChild(new AssetDetailItem(item, {
            onSelect: () => this.handleDetailItemSelect(item),
            onUnselect: () => this.handleDetailItemUnselect(item),
            onRemove: () => this.handleRemoveItem(item)
        }));
    }
    handleDetailItemSelect(item) {
        this.selectedItems.push(item);
        this.updateSelectedItemsList();
    }
    handleDetailItemUnselect(item) {
        this.selectedItems = this.selectedItems.filter((sItem) => sItem !== item);
        this.updateSelectedItemsList();
    }
    handleSelectNone() {
        this.selectedItems = [];
        this.updateSelectedItemsList();

        [].slice.call(this.children).forEach((assetDetailItem) => {
            if (assetDetailItem.selected) {
                assetDetailItem.handleSelect();
            }
        });
    }
    handleSelectAll() {
        const children = [].slice.call(this.children);
        this.selectedItems = children.map((assetDetailItem) => {
            if (!assetDetailItem.selected) {
                assetDetailItem.handleSelect();
            }
            return assetDetailItem.item;
        });
        this.updateSelectedItemsList();
    }
    updateSelectedItemsList() {
        this.selectedItemsList.value = this.selectedItems.map((item) => item.name).join(' ');
    }
    clear() {
        this.innerHTML = "";
    }
}

class AssetDetailItem extends(CustomElement(HTMLLIElement)) {
    static tagName = 'asset-detail-item';
    static tagType = 'li';
    item = null;
    selected = false;
    constructor(item, options) {
        super();

        this.item = item;
        this.onSelect = options.onSelect || Function.prototype;
        this.onUnselect = options.onUnselect || Function.prototype;

        const title = document.createElement('h3');
        title.innerText = item.name;
        this.appendChild(title);

        const infoAndActions = document.createElement('div');
        infoAndActions.classList.add('detail-info-and-actions');

        const select = document.createElement('button');
        select.innerText = 'select';
        select.classList.add('select-button');
        select.addEventListener('click', this.handleSelect.bind(this));
        infoAndActions.append(select);

        const pngInfo = document.createElement('button');
        pngInfo.innerText = 'pnginfo';
        pngInfo.addEventListener('click', this.handlePngInfo.bind(this));
        infoAndActions.append(pngInfo);

        const remove = document.createElement('button');
        remove.innerText = 'remove';
        remove.addEventListener('click', this.handleRemove.bind(this));
        infoAndActions.append(remove);

        this.appendChild(infoAndActions);

        const img = document.createElement('img');
        img.src = encodeURI(item.href);
        img.loading = 'lazy';
        this.appendChild(img);
        this.img = img;
    }
    handleSelect() {
        this.selected = !this.selected;
        if (this.selected) {
            this.classList.add('selected');
            this.onSelect();
        } else {
            this.classList.remove('selected');
            this.onUnselect();
        }
    }
    handlePngInfo(event) {
        console.log('handlePngInfo', event);
        getPngInfo(this.item.href)
            .then(this.showPngInfoDialog.bind(this))
            .catch(console.error);
    }
    showPngInfoDialog(pngInfo) {
        console.log(pngInfo);
        let prompt = '<h3>Prompt</h3>';
        prompt += '<ul>';
        Object.keys(pngInfo.prompt).forEach((key) => {
            prompt += '<li class="promptNode">'
            const node = pngInfo.prompt[key];
            prompt += `<h4 id="promptNode_${key}">${node.class_type} (${key})</h4>`;
            prompt += '<dl>';
            Object.keys(node.inputs).forEach((ikey) => {
                const val = node.inputs[ikey];
                prompt += `<dt>${ikey}: </dt>`;
                prompt += '<dd>';
                if (Array.isArray(val)) {
                    prompt += `<a href="#promptNode_${val[0]}">${pngInfo.prompt[val[0]].class_type} (${val[0]})</a>`
                } else {
                    prompt += `${val}`
                }
                prompt += '<dd>';
                return prompt
            });
            prompt += '</dl>';
            prompt += '</li>';
        });
        prompt += '</ul>';
        fullPrompt.innerHTML = prompt;
        pngInfoDialog.showModal();
    }
    handleRemove() {
        this.remove();
    }
    onMount() {

    }
}

class AssetLink extends (CustomElement(HTMLAnchorElement)) {
    static tagName = "asset-link";
    static tagType = "a";
    highlighted = false;
    highlight(searchText) {
        const regExp = new RegExp(`(${searchText})`,"iu");
        this.highlighted = searchText !== "" && regExp.test(this.name);
        requestAnimationFrame(() => {
            if (this.highlighted) {
                const template = '<mark class="asset-mark">$1</mark>';
                this.innerHTML = this.name.replace(regExp, template);
            } else {
                this.textContent = this.name;
            }
            this.classList.toggle("asset-link--highlighted", this.highlighted);
        });
    }
    onClick(event) {
        event.preventDefault();
        assetDetailListEl.addItemFromLink({
            name: this.name,
            href: this.href,
            type: 'img'
        });
    }
    onMount() {
        if (!this.isImg()) {
            return;
        }
        this.addEventListener('click', this.onClick.bind(this));
    }
    isImg() {
        return imgEnding.test(this.href);
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
    isImg() {
        return this.link.isImg();
    }
    get highlighted() {
        return this.link.highlighted;
    }
    focus() {
        this.link.focus()
    }
}

class AssetList extends (CustomElement(HTMLOListElement)) {
    static tagName = "asset-list";
    static tagType = "ol";
    filterText = "";
    filterShow = false;
    scrollAnim = null;
    highlighted = [];
    onMount() {
        document.getElementById('filteredToggle').addEventListener('change', this.handleFilteredToggle.bind(this));
        document.getElementById('viewAllButton').addEventListener('click', this.handleViewAll.bind(this));
    }
    handleFilteredToggle(event) {
        this.setFilterShow(event.target.checked);
    }
    handleViewAll() {
        assetDetailListEl.clear();
        if (!this.highlighted.length) {
            this.highlighted = [].slice.call(this.children);
        }
        this.highlighted.forEach((item) => {
            if (!item.isImg()) {
                return;
            }
            assetDetailListEl.addItemFromLink({
                name: item.link.name,
                href: item.link.href,
                type: 'img'
            });
        })
    }
    setFilterText(text) {
        this.filterText = text;
        this.highlight();
        localStorage.setItem('filterText', this.filterText);
    }
    setFilterShow(show) {
        this.filterShow = show;
        this.classList.toggle("asset-item--show-filtered", this.filterShow);
        this.scrollToFirstHighlighted();
    }
    scrollToFirstHighlighted() {
        if (!this.highlighted[0]) return;

        cancelAnimationFrame(this.scrollAnim);
        this.scrollAnim = requestAnimationFrame(() => {
            this.highlighted[0].scrollIntoView();
        });
    }
    highlight() {
        this.highlighted = [];
        for (const assetItem of this.children) {
            if (!(assetItem instanceof AssetItem)) continue;

            assetItem.highlight(this.filterText);
            if (assetItem.highlighted) {
                this.highlighted.push(assetItem);
            }
        }
    }
}

function main() {
    AssetLink.define();
    AssetItem.define();
    AssetList.define();
    AssetDetailList.define();
    AssetDetailItem.define();
    FilterInput.define();
}

document.addEventListener("DOMContentLoaded", main);
  ]]>
</script>
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
