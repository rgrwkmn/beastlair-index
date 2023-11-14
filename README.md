# beastlair-index

BEAST LAIR website and image management tools.

These are the custom tools I use to

1. Manage the images I generate with ComfyUI and Automatic1111
2. Generate a static website of image galleries.

## Static Website Generation

### Add New Galleries

Add images to add to a new or existing gallery to the `stagegallery` folder and run the `convertgallery.sh` script.

`$ ./convertgallery stagegallery public/MyFirstGallery`

If the MyFirstGallery folder does not already exist, it will be created. If an `index.md` file doesn't already exist, it will be created from the `tmplt/default-index.md` file, with the `# TITLE` replaced with the folder name like `# MyFirstGallery`.

All the images will be converted to jpegs and added to a `_gallery` sub folder. If there is an existing gallery, the images will be added to it.

### Edit Markdown Files

All `.md` markdown files in the `public` folder and subfolders will be converted to html, so you can make any arbitrary pages you would like, hyperlink them together, create custom galleries by hand, etc.

There are some custom markdown extensions you can use to make this easier.

#### Custom Markdown Extensions

##### $ breadcrumbs

Adding `$ breadcrumbs` to a markdown file will list parent directories up to the home directory of the project (public), so visitors can navigate back up.

##### $ dirlist

Adding `$ dirlist` to a markdown file will list the subdirectories of the current directory excluding any that begin with `_`.

#### $ gallery

Adding `$ gallery` to a markdown file will generate an image gallery with all of the images in the `_gallery` directory child of markdown file's directory. This is automatically created when using the `convertgallery.sh` script.

### Generate the static site

Run the `gen.js` script to convert the markdown files to static html.

`$ node gen.js`

## AI Image Management

A simple interface for managing your trillions of generated images. Based on [ngx-superbindex](https://github.com/gibatronic/ngx-superbindex).

Filter your images by filename using regex. Click `View All` to see all filtered images or click individually to add them to the gallery pane. Check pnginfo. Select them to get a space delimited list of filenames suitable for use on the command line.

### Usage

Use the `beastlair-index.xslt` as an autoindex template with nginx. Make sure you are only serving your output folder and that it doesn't contain anything sensitive because all sub folders and files will be exposed. Adding authentication as shown below is a good idea to prevent anyone crawling and downloading gigabytes of image data.

```
location /my_first_output_path {
  auth_basic "Beast Lair";                     # optional authentication
  auth_basic_user_file /etc/apache2/.htpasswd; # optional authentication
  autoindex on;
  autoindex_format xml;
  xslt_stylesheet /path/to/beastlair-index/beastlair-index.xslt;
  alias /path/to/ComfyUI/output;
  # First attempt to serve request as file, then
  # as directory, then fall back to displaying a 404.
  try_files $uri $uri/ =404;
}
```
