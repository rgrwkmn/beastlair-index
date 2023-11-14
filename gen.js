import { marked } from 'marked';
import fs from 'fs';
import { join } from 'path';
import sizeOf from 'image-size';
import indexhtml from './tmplt/indexhtml.js';
import galleryhtml from './tmplt/galleryhtml.js';

let currentDir = './public';
let currentDirList = [];

const dirList = {
  name: 'dirList',
  level: 'block',
  start(src) { return src.match(/\$ dirlist/)?.index; },
  tokenizer(src, tokens) {
    const rule = /^\$ dirlist/;
    const match = rule.exec(src);

    if (match) {
      const token = {
        type: 'dirList',
        raw: match[0],
        text: match[0].trim(),
        tokens: []
      };
      return token;
    }
  },
  renderer(token) {
    const links = currentDirList.map(
      (dir) => `<a href="./${dir}">${dir}</a>`
    );
    return `<nav class="dirlist">${links.join('')}</nav>`;
  }
};

const breadCrumbs = {
  name: 'breadCrumbs',
  level: 'block',
  start(src) { return src.match(/\$ breadcrumbs/)?.index; },
  tokenizer(src, tokens) {
    const rule = /^\$ breadcrumbs/;
    const match = rule.exec(src);

    if (match) {
      const token = {
        type: 'breadCrumbs',
        raw: match[0],
        text: match[0].trim(),
        tokens: []
      };
      return token;
    }
  },
  renderer(token) {
    const crumbs = currentDir.split('/');
    const crumbLength = crumbs.length;
    const links = crumbs.map((dir, i) => {
      if (i === 0) {
        return `<a href="/">Home</a>`
      }
      if (i === crumbLength - 1) {
        return `<span>${dir}</span>`;
      }
      return `<a href="${Array(crumbLength - 1 - i).fill('../').join()}">${dir}</a>`;
    });
    return `<nav class="breadcrumbs">${links.join(' > ')}</nav>`;
  }
};

const gallery = {
  name: 'gallery',
  level: 'block',
  start(src) { return src.match(/\$ gallery/)?.index; },
  tokenizer(src, tokens) {
    const rule = /^\$ gallery/;
    const match = rule.exec(src);

    if (match) {
      const token = {
        type: 'gallery',
        raw: match[0],
        text: match[0].trim(),
        tokens: []
      };
      return token;
    }
  },
  renderer(token) {
    console.log(currentDir);
    const galleryDir = `${currentDir}/_gallery`;
    const smallJpg = fs.readdirSync(galleryDir).filter((name) => name.match(/small\.jpg$/));

    if (!smallJpg.length) {
      console.error(galleryDir);
      throw new Error('gallery requires small jpgs');
    }

    const withInfo = smallJpg.map((filename) => {
      const imgData = {
        filename: filename,
        ...sizeOf(`${currentDir}/_gallery/${filename}`)
      }
      return imgData;
    });

    return galleryhtml(withInfo);
  }
};

marked.use({ extensions: [dirList, breadCrumbs, gallery] });

const mdEnding = /\.md$/;

function getDirContents(path) {
  return new Promise((resolve, reject) => {
    fs.readdir(path, { withFileTypes: true }, (err, files) => {
      if (err) throw err;

      const jpgs = files.filter((file) => file.name.match(/\.jpg$/)).map((file) => file.name);

      resolve({
        dir: files.filter((file) => file.isDirectory()).filter((file) => file.name.match(/^[^_]/)).map((file) => file.name),
        md: files.filter((file) => file.name.match(mdEnding)).map((file) => file.name),
        jpg: jpgs,
        smallJpg: jpgs.filter((name) => name.match(/small\.jpg$/))
      })
    });
  });
}

function processMarkdown(path) {
  return new Promise((resolve, reject) => {
    if (!path.match(mdEnding)) {
      throw new Error('processMarkdown: path should end with .md');
    }
    fs.readFile(path, 'utf8', (err, md) => {
      if (err) throw err;

      const html = marked.parse(md);
      const fullHtml = indexhtml({ body: html });
      const filePath = path.replace(mdEnding, '.html');

      fs.writeFile(filePath, fullHtml, (err) => {
        if (err) throw err;

        console.log(`wrote file ${filePath}`);
        resolve();
      });
    });
  });
}

async function processDirectory(path) {
  return new Promise(async (resolve) => {
    console.log(`process directory ${path}`);
    currentDir = path;

    const dirContents = await getDirContents(path);
    currentDirList = dirContents.dir;

    console.log(`process markdown files: ${dirContents.md.join(', ')}`);

    for (let i = 0; i < dirContents.md.length; i++) {
      await processMarkdown(join(currentDir, dirContents.md[i]))
    }

    resolve(dirContents.dir);
  });
}

async function processDirectoryTree(path) {
  const dirs = await processDirectory(path);
  for (let i = 0; i < dirs.length; i++) {
    await processDirectoryTree(join(path, dirs[i]));
  }
}

(async () => {
  await processDirectoryTree('./public');
  console.log('finished');
})();
