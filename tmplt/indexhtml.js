export default function({ body, title='BEAST LAIR' }) {
  return `
<!DOCTYPE html>
<html>
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>${title}</title>
    <link href="/style.css" rel="stylesheet" />
    <meta name="description" content="Infinite visions from the dankest depths of the neural net." />
    <meta name="color-scheme" content="dark" />
    <meta name="theme-color" content="#040605">
    <meta property="og:image" content="https://beastlair.ai/BeastLair/BeastLair-Everjourney-Tuned-2023-08-18-Edge_00001_.jpg" />

    <link rel="apple-touch-icon" sizes="57x57" href="/_favicon/apple-icon-57x57.png">
    <link rel="apple-touch-icon" sizes="60x60" href="/_favicon/apple-icon-60x60.png">
    <link rel="apple-touch-icon" sizes="72x72" href="/_favicon/apple-icon-72x72.png">
    <link rel="apple-touch-icon" sizes="76x76" href="/_favicon/apple-icon-76x76.png">
    <link rel="apple-touch-icon" sizes="114x114" href="/_favicon/apple-icon-114x114.png">
    <link rel="apple-touch-icon" sizes="120x120" href="/_favicon/apple-icon-120x120.png">
    <link rel="apple-touch-icon" sizes="144x144" href="/_favicon/apple-icon-144x144.png">
    <link rel="apple-touch-icon" sizes="152x152" href="/_favicon/apple-icon-152x152.png">
    <link rel="apple-touch-icon" sizes="180x180" href="/_favicon/apple-icon-180x180.png">
    <link rel="icon" type="image/png" sizes="192x192"  href="/_favicon/android-icon-192x192.png">
    <link rel="icon" type="image/png" sizes="32x32" href="/_favicon/favicon-32x32.png">
    <link rel="icon" type="image/png" sizes="96x96" href="/_favicon/favicon-96x96.png">
    <link rel="icon" type="image/png" sizes="16x16" href="/_favicon/favicon-16x16.png">
    <link rel="manifest" href="/_favicon/manifest.json">
    <meta name="msapplication-TileColor" content="#040605">
    <meta name="msapplication-TileImage" content="/_favicon/ms-icon-144x144.png">

  </head>
  <body>
    ${body}
  </body>
</html>
  `
}