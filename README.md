# docky.sh

Docky is a script to facilitate the use of Docker based on Laravel Sail script.

Docky was written with PHP/Node/Laravel developers in mind.  
It can run composer, php, phpcs, phpmd, npm and npx.

By default it'll use the latest image tag, but you can control the images using
a `.docky.env` file.  
See the `.docky.env.example` file.

You can add an extra volume when running Composer by adding
`COMPOSER_EXTRA_VOLUME` variable to `.docky.env`.

Example:

```dotenv
COMPOSER_EXTRA_VOLUME="/path/in/host:/path/in/container"
```

## Changelog

- **v1.4**:
  - Adds support for an extra volume when running Composer
- **v1.3**:
  - Adds _PHPUnit_ support
- **v1.2.2**:
  - Adds documentation
  - Fix _`"docker: invalid reference format."`_ error
- **v1.2.1**:
  - Adds `COMPOSER_IMAGE` environment var support
- **v1.2**:
  - Adds `.docky.env` support
- **v1.1**:
  - Changed `node:lts-alpine` to `node:lts`
- **v1.0**:
  - Initial release
