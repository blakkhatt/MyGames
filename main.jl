using Plots

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

# Plot Mandelbrot
m = mandelbrot(400, 400, 100)
plot(heatmap(m, color=:viridis, title="Babies Mandelbrot"))

# Plot Julia
c = -0.7 + 0.27015im
j = julia(400, 400, 100, c)
plot(heatmap(j, color=:plasma, title="Julia Set"))

# Simple battle simulation
struct FractalFighter
    name::String
    health::Float64
    power::Float64
end

function attack(attacker::FractalFighter, defender::FractalFighter)
    damage = rand() * attacker.power
    defender.health -= damage
    println("$(attacker.name) attacks $(defender.name) for $damage damage!")
    if defender.health <= 0
        println("$(defender.name) is defeated!")
        return true
    end
    return false
end

# AI logic: simple random choice
function ai_turn(fighter::FractalFighter, opponent::FractalFighter)
    if rand() > 0.5
        return attack(fighter, opponent)
    else
        println("$(fighter.name) defends!")
        return false
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

# Game loop
function battle(player::FractalFighter, enemy::FractalFighter)
    turn = 1
    while player.health > 0 && enemy.health > 0
        println("\nTurn $turn")
        println("$(player.name) health: $(player.health)")
        println("$(enemy.name) health: $(enemy.health)")
        
        # Player turn
        if player_turn(player, enemy)
            break
        end
        
        # Enemy turn (AI)
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

# Create fighters
babies_mandelbrot = FractalFighter("Babies Mandelbrot", 100.0, 20.0)
julia_sets = FractalFighter("Julia Sets", 100.0, 18.0)

# Start battle
battle(babies_mandelbrot, julia_sets)