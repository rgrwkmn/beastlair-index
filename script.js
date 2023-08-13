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
        const regExp = new RegExp(`(${searchText})`,"iu");
        this.highlighted = searchText !== "" && regExp.test(this.name);
        if (this.highlighted) {
            const template = '<mark class="asset-mark">$1</mark>';
            this.innerHTML = this.name.replace(regExp, template);
        } else {
            this.textContent = this.name;
        }
        this.classList.toggle("asset-link--highlighted", this.highlighted);
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
    AssetList.define();
}
document.addEventListener("DOMContentLoaded", main);