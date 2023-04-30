// Created by Leopold Lemmermann on 30.04.23.

import Vapor

var env = try Environment.detect()
try LoggingSystem.bootstrap(from: &env)

let app = Application(env)

app.configure()

defer { app.shutdown() }
try app.run()
