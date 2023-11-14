export default function({ body, title='BEAST LAIR' }) {
  return `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${title}</title>
    <link href="/style.css" rel="stylesheet" />
    <meta name="description" content="">

  </head>
  <body>
    ${body}
  </body>
</html>
  `
}