#The Ultimate Elm Haskell Stack Builder!

This stack is built on:

####Front-End
* [x] Elm (Front-End)
* [ ] Yarn

####Back-End
* [x] Haskell
    * [x] Servant
    * [x] Opaleye
* [x] Postgres (DB)

####Ops
* [x] Docker
* [ ] Shell for auto building entire stack
* [ ] Elastic Beanstalk
* [ ] CircleCI


Eventually it will include a Lego Style Architecture with branches for quickly scaffolding common apps

* [x] base
  * [ ] Oauth
  * [ ] Mailchimp example
  * [ ] Image storage

## Setup

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

then go to localhost:3000
