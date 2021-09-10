function encode_bottom(input::String)
    encoded_chars = String[]
    sizehint!(encoded_chars, length(input))
    for char in input
        current_string = ""
        value = Int(char)
        if value == 0
            current_string = "❤️"
        end
        while value != 0
            if value >= 200
                current_string *= "🫂"
                value -= 200
            elseif value >= 50
                current_string *= "💖"
                value -= 50
            elseif value >= 10
                current_string *= "✨"
                value -= 10
            elseif value >= 5
                current_string *= "🥺"
                value -= 5
            elseif value >= 1
                current_string *= ","
                value -= 1
            end
        end
        
        push!(encoded_chars, current_string)
    end

    return join(encoded_chars .* "👉👈")
end

function decode_bottom(input::String)
    emoji_to_value = Dict{String,Int}("🫂" => 200, "💖" => 50, "✨" => 10, "🥺" => 5, "," => 1, "❤️" => 0)
    bottom_chars = keys(emoji_to_value)

    if !all(contains(join(bottom_chars) * "👉👈", i) for i in input)
        error("Input string contains a character not in the Bottom specification.")
    end

    if !endswith(input, "👉👈")
        error("The input string should end with the byte separator.")
    end

    decoded_chars = Char[]
    split_input = split(input, "👉👈")
    sizehint!(decoded_chars, length(split_input) - 1)

    for encoded_byte in split_input[1:length(split_input) - 1]
        char_code = 0
        for char in bottom_chars
            char_code += count(char, encoded_byte) * emoji_to_value[char]
        end
        push!(decoded_chars, Char(char_code))
    end
    
    # An amusing one-liner version of the above for-loop. Saves no time whatsoever.
    #output_chars = Char[Char(sum(count(char, encoded_byte) * emoji_to_value[char] for char in bottom_chars)) for encoded_byte in split_input[1:length(split_input) - 1]]

    return join(decoded_chars)
end

function write_output(data::String, filename::String)
    open(filename, "w") do output_file
        write(output_file, data)
    end
end

function main()
    if length(ARGS) != 3
        println("Usage: $(PROGRAM_FILE) [--bottomify/--regress] input_file output_file")
        return
    end

    input_file = ARGS[2]
    output_file = ARGS[3]

    if ARGS[1] == "--bottomify"
        input_text = read(input_file, String)
        result = encode_bottom(input_text)
        write_output(result, output_file)
    elseif ARGS[1] == "--regress"
        input_text = string(readchomp(input_file))
        result = decode_bottom(input_text)
        write_output(result, output_file)
    else
        println("Invalid option specified (expected --bottomify or --regress).")
    end
end

main()