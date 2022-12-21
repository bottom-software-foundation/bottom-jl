function encode_char(input::Char)
    value = Int(input)
    if value == 0
        current_string = "❤️"
    else
        current_string = ""
        if value >= 200
            copies, value = divrem(value, 200)
            current_string *= "🫂" ^ copies
        end
        if value >= 50
            copies, value = divrem(value, 50)
            current_string *= "💖" ^ copies
        end
        if value >= 10
            copies, value = divrem(value, 10)
            current_string *= "✨" ^ copies
        end
        if value >= 5
            copies, value = divrem(value, 5)
            current_string *= "🥺" ^ copies
        end
        if value != 0
            current_string *= "," ^ value
        end
    end

    return current_string * "👉👈"
end

encode_bottom(input::String) = input |> collect .|> encode_char |> join

function decode_byte(encoded_byte::SubString{String}, emoji_to_value::Dict{String, Int})
    # Decodes a string of bottom characters into the single character they represent
    total = 0
    for key in keys(emoji_to_value)
        total += count(key, encoded_byte) * emoji_to_value[key]
    end
    return Char(total)
end

function decode_bottom(input::String)
    emoji_to_value = Dict{String, Int}("🫂" => 200, "💖" => 50, "✨" => 10, "🥺" => 5, "," => 1, "❤️" => 0)
    byte_separator = "👉👈"
    all_bottom_chars = [emoji_to_value |> keys |> collect ; byte_separator]

    if sum([count(char, input) * length(char) for char in all_bottom_chars]) ≠ length(input)
        error("Input string contains a character not in the Bottom specification.")
    end

    if !endswith(input, byte_separator)
        error("The input string should end with the byte separator.")
    end

    input_to_decode = @view split(input, byte_separator)[1:end-1]
    decoded_chars = [decode_byte(encoded_char, emoji_to_value) for encoded_char in input_to_decode]

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
