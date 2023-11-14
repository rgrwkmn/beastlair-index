export default function(jpgs) {
	return `
<div class="gallery">
	${jpgs.map(({ filename, height, width }) =>
		`<a href="./_gallery/${filename.replace(/-small\.jpg/, '.jpg')}"><img class="small" src="./_gallery/${filename}" loading="lazy" height="${height}" width="${width}"/></a>`
	).join('')}
</div>
	`
}