import azure.functions as func

app = func.FunctionApp()

@app.function_name(name="HelloWorld")
@app.route(route="hello")
def hello_world(req: func.HttpRequest) -> func.HttpResponse:
    return func.HttpResponse("Hello, World!")