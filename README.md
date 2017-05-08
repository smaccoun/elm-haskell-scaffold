# The Ultimate Elm Haskell Stack Builder!

**Note:** This repo will be well-maintained and used heavily. Contributors are always welcome!

This stack is built on:

#### Front-End
* [x] Elm (Front-End)
* [ ] Yarn

#### Back-End
* [x] Haskell
    * [x] Servant
    * [x] Opaleye
* [x] Postgres (DB)

#### Ops
* [x] Docker
* [ ] Shell for auto building entire stack
* [ ] Elastic Beanstalk
* [ ] CircleCI

#### Codegen
* [ ] ([servant-elm](https://www.google.com)) ???
* [ ] custom ?? (utilize RemoteData in codegen)
* [ ] swagger gen


#### Documentation
* [ ] Swagger

### Eventually it will include a Lego Style Architecture with branches for quickly scaffolding common apps

Branches:

* [x] base
  * [ ] Oauth
  * [ ] Mailchimp example
  * [ ] Image storage

## Setup

TODO: Make bash shell script or haskell setup script or Makefile to build entire stack plus setup env variables and DB etc

```
--TODO: Initialize DB

--Startup back-end API

$ cd back-end
$ stack build
$ stack exec project-exe

--Startup front-end
$ cd front-end
$ yarn install
$ yarn start
```

then go to **localhost:3000**
