using Genie, Genie.Router, Genie.Renderer.Html

# Include the game logic
include("main.jl")

# Route to run the game
route("/battle") do
    # Capture the output
    old_stdout = stdout
    io = IOBuffer()
    redirect_stdout(io)
    try
        # Run the battle
        babies_mandelbrot = FractalFighter("Babies Mandelbrot", 100.0, 20.0)
        julia_sets = FractalFighter("Julia Sets", 100.0, 18.0)
        battle(babies_mandelbrot, julia_sets)
    finally
        redirect_stdout(old_stdout)
    end
    output = String(take!(io))
    html("<pre>$output</pre>")
end

# Home page
route("/") do
    html("""
    <h1>Fractal Battle Game</h1>
    <p>Watch Babies Mandelbrot fight Julia Sets!</p>
    <a href='/battle'>Start Battle</a>
    """)
end

# Start the server
Genie.startup()