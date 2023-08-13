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
    highlight(highlightedGraphemes) {
        const regExp = new RegExp(`^(${highlightedGraphemes})`,"iu");
        this.highlighted = highlightedGraphemes !== "" && regExp.test(this.name);
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
    highlight(highlightedGraphemes) {
        this.link.highlight(highlightedGraphemes);
        const filtered = highlightedGraphemes === "" || this.link.highlighted;
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
    highlightedGraphemes = "";
    keystroke = this.keystroke.bind(this);
    filterInput = null;
    highlight(key) {
	    console.log(key);
        if (key === "") {
            this.highlightedGraphemes = ""
        } else {
            this.highlightedGraphemes += key.toLocaleLowerCase()
        }
        let firstHighlightedAssetItem;
        for (const assetItem of this.children) {
            if (!(assetItem instanceof AssetItem)) continue;
            assetItem.highlight(this.highlightedGraphemes);
            if (firstHighlightedAssetItem === undefined && assetItem.highlighted) {
                firstHighlightedAssetItem = assetItem
            }
        }
        if (firstHighlightedAssetItem) {
            firstHighlightedAssetItem.focus();
            firstHighlightedAssetItem.scrollIntoView({
                behavior: "smooth",
                block: "nearest"
            });
        }
	    console.log('grapheme', this.highlightedGraphemes);
        this.searchText.innerText = this.highlightedGraphemes;
    }
    mount() {
        this.searchText = document.getElementById('searchText');
        document.body.addEventListener("keyup", this.keystroke);
    }
    keystroke({key: key}) {
        console.log('key', key);
        if (key === "Escape") {
            this.highlight("");
            return
        }
        if (key === "Backspace" && this.highlightedGraphemes.length > 0) {
            this.highlight(this.highlightedGraphemes.slice(0, -1));
        }
        const notGrapheme = key.length !== 1;
        if (notGrapheme) {
            return
        }
        this.highlight(key)
    }
}
function main() {
    AssetLink.define();
    AssetItem.define();
    AssetList.define()
}
document.addEventListener("DOMContentLoaded", main);