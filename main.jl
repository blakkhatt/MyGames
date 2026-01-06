using Plots, VideoIO, FileIO

# Function to generate Mandelbrot set
function mandelbrot(h, w, max_iter)
    y = range(-1.5, 1.5, length=h)
    x = range(-2.0, 1.0, length=w)
    m = zeros(h, w)
    for i in 1:h
        for j in 1:w
            c = x[j] + im * y[i]
            z = 0 + 0im
            iter = 0
            while abs(z) < 2 && iter < max_iter
                z = z^2 + c
                iter += 1
            end
            m[i, j] = iter
        end
    end
    return m
end

# Function to generate Julia set
function julia(h, w, max_iter, c)
    y = range(-1.5, 1.5, length=h)
    x = range(-2.0, 1.0, length=w)
    m = zeros(h, w)
    for i in 1:h
        for j in 1:w
            z = x[j] + im * y[i]
            iter = 0
            while abs(z) < 2 && iter < max_iter
                z = z^2 + c
                iter += 1
            end
            m[i, j] = iter
        end
    end
    return m
end

# Function to generate Burning Ship fractal
function burning_ship(h, w, max_iter)
    y = range(-1.8, 0.8, length=h)
    x = range(-2.5, 1.0, length=w)
    m = zeros(h, w)
    for i in 1:h
        for j in 1:w
            c = x[j] + im * y[i]
            z = 0 + 0im
            iter = 0
            while abs(z) < 2 && iter < max_iter
                z = (abs(real(z)) + im * abs(imag(z)))^2 + c
                iter += 1
            end
            m[i, j] = iter
        end
    end
    return m
end

# Plot Mandelbrot
m = mandelbrot(400, 400, 100)
plot(heatmap(m, color=:viridis, title="Babies Mandelbrot"))

# Plot Julia
c = -0.7 + 0.27015im
j = julia(400, 400, 100, c)
plot(heatmap(j, color=:plasma, title="Julia Set"))

# Enhanced battle simulation
mutable struct FractalFighter
    name::String
    health::Float64
    max_health::Float64
    power::Float64
    defense::Float64
    ability::String
    ability_used::Bool
end

function attack(attacker::FractalFighter, defender::FractalFighter)
    base_damage = rand() * attacker.power
    damage = max(0, base_damage - defender.defense)
    defender.health -= damage
    println("$(attacker.name) attacks $(defender.name) for $(round(damage, digits=1)) damage!")
    if defender.health <= 0
        println("$(defender.name) is defeated!")
        return true
    end
    return false
end

function use_ability(fighter::FractalFighter, opponent::FractalFighter)
    if fighter.ability_used
        return false
    end
    fighter.ability_used = true
    if fighter.ability == "Deep Zoom"
        fighter.power *= 1.5
        println("$(fighter.name) uses Deep Zoom! Power increased!")
    elseif fighter.ability == "Iterate Heal"
        heal = fighter.max_health * 0.3
        fighter.health = min(fighter.max_health, fighter.health + heal)
        println("$(fighter.name) uses Iterate Heal! Healed for $heal health!")
    elseif fighter.ability == "Burning Burst"
        damage = rand() * 30
        opponent.health -= damage
        println("$(fighter.name) uses Burning Burst! Deals $damage extra damage!")
    elseif fighter.ability == "Variant Shift"
        fighter.defense *= 1.5
        println("$(fighter.name) uses Variant Shift! Defense increased!")
    end
    return false
end

# Improved AI with abilities
function ai_turn(fighter::FractalFighter, opponent::FractalFighter)
    defend_prob = fighter.health / fighter.max_health < 0.5 ? 0.6 : 0.2
    ability_prob = !fighter.ability_used && fighter.health / fighter.max_health < 0.7 ? 0.3 : 0.0
    r = rand()
    if r < defend_prob
        println("$(fighter.name) defends!")
        return false
    elseif r < defend_prob + ability_prob
        return use_ability(fighter, opponent)
    else
        return attack(fighter, opponent)
    end
end



# Player turn with input
function player_turn(player::FractalFighter, opponent::FractalFighter)
    println("Your turn! Choose: (a)ttack or (d)efend")
    choice = readline()
    if choice == "a"
        return attack(player, opponent)
    else
        println("$(player.name) defends!")
        return false
    end
end

# AI battle with animated fractals
function ai_battle(player::FractalFighter, enemy::FractalFighter)
    if !isdir("frames")
        mkdir("frames")
    end
    turn = 1
    while player.health > 0 && enemy.health > 0
        println("\nTurn $turn")
        println("$(player.name) health: $(round(player.health, digits=1))")
        println("$(enemy.name) health: $(round(enemy.health, digits=1))")
        
        # Animate fractals: change parameters each turn
        zoom = 1 + turn * 0.05
        center_x = -0.5 + turn * 0.005
        center_y = 0.0
        y_range = range(center_y - 1.5/zoom, center_y + 1.5/zoom, length=200)
        x_range = range(center_x - 2.0/zoom, center_x + 1.0/zoom, length=200)
        
        m = zeros(200, 200)
        for i in 1:200, j in 1:200
            c = x_range[j] + im * y_range[i]
            z = 0 + 0im
            iter = 0
            while abs(z) < 2 && iter < 50
                z = z^2 + c
                iter += 1
            end
            m[i, j] = iter
        end
        
        c_julia = -0.7 + 0.27015im + turn * 0.01 + im * turn * 0.005
        j = julia(200, 200, 50, c_julia)
        
        # Create frame
        p1 = heatmap(m, color=:viridis, title="$(player.name)\nHealth: $(round(player.health, digits=1))")
        p2 = heatmap(j, color=:plasma, title="$(enemy.name)\nHealth: $(round(enemy.health, digits=1))")
        p = plot(p1, p2, layout=(1,2), size=(800,400))
        savefig(p, "frames/frame_$(lpad(turn, 3, '0')).png")
        
        if ai_turn(player, enemy)
            break
        end
        
        if ai_turn(enemy, player)
            break
        end
        
        turn += 1
        sleep(0.2)
    end
    
    # Final frame
    winner = player.health > 0 ? player : enemy
    p1 = heatmap(m, color=:viridis, title="$(player.name)\nHealth: $(round(player.health, digits=1))")
    p2 = heatmap(j, color=:plasma, title="$(enemy.name)\nHealth: $(round(enemy.health, digits=1))")
    p = plot(p1, p2, layout=(1,2), size=(800,400), title="$(winner.name) Wins!")
    savefig(p, "frames/frame_$(lpad(turn, 3, '0')).png")
    
    if player.health > 0
        println("\n$(player.name) wins!")
    else
        println("\n$(enemy.name) wins!")
    end
    
    # Create video
    frame_files = sort([f for f in readdir("frames") if endswith(f, ".png")])
    imgs = [load("frames/$f") for f in frame_files]
    VideoIO.save("battle.mp4", imgs, framerate=3)
    println("Animated video saved as battle.mp4")
end

# Interactive player battle
function player_battle(player::FractalFighter, enemy::FractalFighter)
    turn = 1
    while player.health > 0 && enemy.health > 0
        println("\nTurn $turn")
        println("$(player.name) health: $(player.health)")
        println("$(enemy.name) health: $(enemy.health)")
        
        if player_turn(player, enemy)
            break
        end
        
        if ai_turn(enemy, player)
            break
        end
        
        turn += 1
    end
    
    if player.health > 0
        println("\n$(player.name) wins!")
    else
        println("\n$(enemy.name) wins!")
    end
end

# Create fighters with abilities
babies_mandelbrot = FractalFighter("Babies Mandelbrot", 100.0, 100.0, 20.0, 5.0, "Deep Zoom", false)
julia_sets = FractalFighter("Julia Sets", 100.0, 100.0, 18.0, 4.0, "Iterate Heal", false)

# Choose mode
println("Choose mode: (i)nteractive player battle or (a)i demo")
mode = readline()
if mode == "i"
    player_battle(babies_mandelbrot, julia_sets)
else
    ai_battle(babies_mandelbrot, julia_sets)
end