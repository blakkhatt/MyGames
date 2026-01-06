using HTTP, Plots

# Set headless backend for saving plots
ENV["GKSwstype"] = "nul"

# Include game logic
include("main.jl")

# Save fractal images
function save_fractals()
    m = mandelbrot(400, 400, 100)
    p1 = plot(heatmap(m, color=:viridis, title="Babies Mandelbrot"))
    savefig(p1, "mandelbrot.png")
    
    c = -0.7 + 0.27015im
    j = julia(400, 400, 100, c)
    p2 = plot(heatmap(j, color=:plasma, title="Julia Set"))
    savefig(p2, "julia.png")
    
    # Add Burning Ship
    bs = burning_ship(400, 400, 100)
    p3 = plot(heatmap(bs, color=:inferno, title="Burning Ship"))
    savefig(p3, "burning_ship.png")
    
    # Another Julia
    c2 = 0.285 + 0.01im
    j2 = julia(400, 400, 100, c2)
    p4 = plot(heatmap(j2, color=:magma, title="Julia Variant"))
    savefig(p4, "julia2.png")
end

save_fractals()

# Improved AI with strategy
function ai_turn(fighter::FractalFighter, opponent::FractalFighter)
    # Strategy: if low health, defend more
    defend_prob = fighter.health < 50 ? 0.7 : 0.3
    if rand() < defend_prob
        println("$(fighter.name) defends!")
        return false
    else
        return attack(fighter, opponent)
    end
end

# Tournament battle
function tournament(fighters::Vector{FractalFighter})
    println("Fractal Battle Tournament Begins!")
    winners = copy(fighters)
    round = 1
    while length(winners) > 1
        println("\n=== Round $round ===")
        next_round = FractalFighter[]
        for i in 1:2:length(winners)
            if i+1 <= length(winners)
                p1 = winners[i]
                p2 = winners[i+1]
                println("\nBattle: $(p1.name) vs $(p2.name)")
                battle(p1, p2)
                if p1.health > 0
                    push!(next_round, p1)
                    p1.health = 100.0  # Reset for next
                else
                    push!(next_round, p2)
                    p2.health = 100.0
                end
            else
                push!(next_round, winners[i])
            end
        end
        winners = next_round
        round += 1
    end
    println("\n🏆 Tournament Winner: $(winners[1].name)!")
end

# Handler
function handler(req)
    if req.target == "/"
        html = """
        <h1>Fractal Battle Arena</h1>
        <img src="/mandelbrot.png" width="300" alt="Mandelbrot">
        <img src="/julia.png" width="300" alt="Julia">
        <img src="/burning_ship.png" width="300" alt="Burning Ship">
        <img src="/julia2.png" width="300" alt="Julia Variant">
        <br><a href='/battle'>Start Tournament</a>
        """
        return HTTP.Response(200, ["Content-Type" => "text/html"], html)
    elseif req.target == "/battle"
        pipe = Pipe()
        redirect_stdout(pipe)
        try
            fighters = [
                FractalFighter("Babies Mandelbrot", 100.0, 100.0, 20.0, 5.0, "Deep Zoom", false),
                FractalFighter("Julia Sets", 100.0, 100.0, 18.0, 4.0, "Iterate Heal", false),
                FractalFighter("Burning Ship", 100.0, 100.0, 22.0, 6.0, "Burning Burst", false),
                FractalFighter("Julia Variant", 100.0, 100.0, 19.0, 3.0, "Variant Shift", false)
            ]
            tournament(fighters)
        finally
            close(pipe.in)
            redirect_stdout(stdout)
        end
        output = read(pipe.out, String)
        html = "<pre>$output</pre><br><a href='/'>Back</a>"
        return HTTP.Response(200, ["Content-Type" => "text/html"], html)
    elseif occursin(".png", req.target)
        file = replace(req.target, "/" => "")
        if isfile(file)
            return HTTP.Response(200, ["Content-Type" => "image/png"], read(file))
        else
            return HTTP.Response(404, "Image not found")
        end
    else
        return HTTP.Response(404, "Not found")
    end
end

println("Starting server on http://127.0.0.1:8080")
HTTP.serve(handler, "127.0.0.1", 8080)