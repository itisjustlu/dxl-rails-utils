# Clients module

Client module es un wrapper de faraday para hacer llamados http de una manera muy sencilla.

## Table de contenidos
[Getting Started](#gettingStarted)  
[Ejemplos](#example)  
[Headers](#headers)

## Getting Started
Recomendamos poner los clients dentro de app/lib/clients, lo primero que debemos hacer es crear un application_client.rb dentro de la carpeta 
`lib`. Todos nuestros clientes heredaran de este application client

```ruby
# app/lib/application_client.rb

class ApplicationClient < ::DXL::Services::ApplicationService
  behave_as :client
end
```

Behave as es una feature de TH modules para poder agregar modulos a nuestros servicios / ruby classes para cambiar
su comportamiento.

En este caso, estamos incluyendo el ClientModule provisto por TH que nos agregar metodos de instancia y metodos de clase
para poder performar llamados http.

## Ejemplos
<a name="examples" />

Asumamos que queremos hacer una llamada GET a `https://jsonplaceholder.typicode.com/comments` que nos devolvera un array de comentarios.

Para hacer podriamos crear un cliente bajo el modulo `Comments` dentro de clients

```ruby
# app/lib/clients/comments/finder.rb

module Clients
  module Comments
    class Finder < ApplicationClient
    end
  end
end
```

Lo primero que deberiamos hacer es declarar la url a la cual vamos a llamar para performar el request

```ruby
private

def url
  "https://jsonplaceholder.typicode.com/comments"
end
```

Para poder llamar a la api con metodo `GET` deberiamos usar `do_get_request` dentro del metodo call

```ruby
def call
  do_get_request
end
```

Ejemplo de uso
```
client = Clients::Comments::Finder.new
client.call

client.body
# => [{"postId": 1,"id": 1,"name": "id labore ex et quam laborum","email": "Eliseo@gardner.biz","body": "laudantium enim quasi est quidem magnam voluptate ipsam eos\ntempora quo necessitatibus\ndolor quam autem quasi\nreiciendis et nam sapiente accusantium"}]

client.status
#=> 200
```

`body` devuelve la respuesta json
`status` devuelve el status del llamado http

Si quisieramos paras parametros url, deberiamos agregarlos al metodo `params`

```ruby
private

def params
  {
    limit: 20,
    page: 2
  }
end
```

---
De la misma manera podriamos hacer llamados http a un solo recurso, por ejemplo la url
`https://jsonplaceholder.typicode.com/comments/4`. Recomendamos usar un nuevo archivo por cada
url distinta que querramos usar y cada metodo, siguiendo la convencion
```
GET /comments => Finder
GET /comments/:id => Retriever
POST /comments => Creator
PUT /comments/:id => Updater
DELETE /comments/:id => Destroyer
```

Ejemplo
```ruby
# app/lib/clients/comments/retriever.rb

module Clients
  module Comments
    class Retriever < ApplicationClient
      def initialize(id)
        @id = id
      end
      
      def call
        do_get_request
      end
      
      private
      
      def url
        "https://jsonplaceholder.typicode.com/comments/#{@id}"
      end
    end
  end
end
```

Ejemplo:
```
client = Clients::Comments::Retriever.new(4)
client.call

client.body
# => {"postId": 1,"id": 4,"name": "alias odio sit","email": "Lew@alysha.tv","body": "non et atque\noccaecati deserunt quas accusantium unde odit nobis qui voluptatem\nquia voluptas consequuntur itaque dolor\net qui rerum deleniti ut occaecati"}
```

Si quisieramos hacer un llamado post para crear un nuevo recurso, deberiamos pasar parametros dentro de body_params.

```ruby
# app/lib/clients/comments/creator.rb

module Clients
  module Comments
    class Creator < ApplicationClient
      def initialize(body)
        @body = body
      end
      
      def call
        do_post_request
      end
      
      private
      
      def url
        "https://jsonplaceholder.typicode.com/comments"
      end
      
      def body_params
        @body
      end
    end
  end
end
```

Todos los parametros puestos en `body_params` van a ser pasados con el content type application/json

Ejemplo:

```ruby
client = ::Clients::Comments::Creator.new({ name: 'Lu', email: 'lu@lu.com' })
client.call
client.status # => 200
```

Todos los metodos disponibles son
```
do_get_request
do_post_request
do_patch_request
do_put_request
do_delete_request
```

## Headers

Si se quiere agregar headers a sus requests, existe el metodo `headers` donde
se le puede pasar un hash

```ruby
private

def headers
  {
    'Authorization' => 'Bearer xxx'
  }
end
```
