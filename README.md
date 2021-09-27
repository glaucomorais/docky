# docky.sh

Docky is a script to facilitate the use of Docker based on Laravel Sail script.

Docky was written with PHP/Node/Laravel developers in mind.  
It can run composer, php, phpcs, phpmd, npm and npx.

By default it'll use the latest image tag, but you can control the images using
a `.docky.env` file.  
See the `.docky.env.example` file.

## Changelog

- v1.2.2:
  - Add some documentation
  - Fix "docker: invalid reference format." error
- v1.2.1:
  - Add COMPOSER_IMAGE environment var support
- v1.2:
  - Add .docky.env support
- v1.1:
  - Changed node:lts-alpine to node:lts
- v1.0:
  - Initial release
