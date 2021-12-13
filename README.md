# SWAPCA 
#### (SWAP - Challenge Accepted)

This application help us to retrieve issues registered in any github's public repository and receive it in our webhook nicely formatted.

## Builded with
 - Elixir 1.12
 - [HTTPoison](https://hexdocs.pm/httpoison/HTTPoison.html)
 - [Poison](https://hexdocs.pm/poison/Poison.html)
 - [Distillery](https://hexdocs.pm/distillery/2.0.0/home.html)

## How it works
![This is an image](./assets/spca_diagram-Page-2.drawio.png)


## How to setup
I created that application to send data to a [Webhook.Site API](https://webhook.site/), so you must put your URL in config/config.exs file at :swapca, :webhook_url.
```
...
config :swapca, webhook_url: "https://webhook.site/245c2373-4f76-4b
...
```

Other than that, most of the presetted data should be fine to run the first and fast test.

In order to reproduce the test scenario where the application must wait 24 hours to send the data for the webhook we must set the configuration :swapca, :swapca, send_after to 86400000



## How to run

You can run in a docker image or directly on your environment.

#### Running in a docker container

Using the command below a image named "swapca:latest" will be created.

```
make build
```

Now you can easily run from ther image with:

```
make run-image
```

#### Running directly on your environment

If you prefer run on your environment, it is available the command below to help you:

```
make install compile run
```

#### How it looks like

In both scenarios the execution should looks like that:
![This is an image](./assets/swapca_mix_run.GIF)

## Where it could be better?

 - Tests:
    - I should be able to run more unit and integrated tests.
    - I missed a test coverage reporting tool.
    - I need to learn to mock
 - UI
    -  I found that using "IO.read/2" in a GenServer was not the best approach. When trying to run the application in its release version it cannot read the console.
 - State
    - It could create a GenServer to keep the state of the items in the queue.
    - Another option would be to put it in a NoSQL database, facilitating the storage of the message already in JSON, to be consulted at the right time.
