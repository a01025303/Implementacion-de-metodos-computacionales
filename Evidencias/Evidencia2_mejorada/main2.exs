# 

# 2022-06-10

# Andreina Sananez / A01024927
# Ana Paula Katsuda / A01025303


defmodule ParallelHighlighter do
    # Main function
    def get_token_parallel(in_filename, out_filename) do
        # Save read data in token
        token =
        # Read in file
        in_filename
        # Make it a stream
        |>File.stream!()
        |>Enum.map(&regex(&1))
        # Turn into string using join
        |> Enum.join()
        #Inspector to see how file was read
        #|> IO.inspect()

        # Define current date
        date = Date.utc_today()
        
        
        # General html text insert with regex data and date
        final_html = "
            <!DOCTYPE html>
                <html>
                <head>
                    <title>JSON Code</title>
                    <link rel='stylesheet' href='token_colors.css'>
                    <link href='https://fonts.googleapis.com/css2?family
                    =Montserrat&display=swap' rel='stylesheet'>
                </head>
                <body>
                    <center><h1>JSON Syntax Highlighter</h1></center>
                    <h3>Date: #{date}</h3>
                    <pre> 
#{token}
                    </pre>
                </body>
                </html>"
        # Write the final html in out file
        File.write(out_filename, final_html)
    end

    # Definition of tail function to evaluate regex
    def regex(line), do: regex_tail(line, [])
    # Function that matches regex expressions for each token
    defp regex_tail(line, new_content) when line != [] do
        cond do
            # Look for punctuation
            Regex.match?(~r/^({|}|\s*:|,|\[|\])(?!<)/, line) -> 
                content = Regex.run(~r/^({|}|\s*:|,|\[|\])(?!<)/, line)
                new_content = 
                ["<span class='punctuation'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            #Look for object key
            Regex.match?(~r/^("[-:\w]*")(?=\s*:)/, line) -> 
                content = Regex.run(~r/^("[-:\w]*")(?=\s*:)/, line)
                new_content = 
                ["<span class='object-key'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for strings
            Regex.match?(~r/^("\w*\s?[^"]*")(?!:)/, line) -> 
                content = Regex.run(~r/^("\w*\s?[^"]*")(?!:)/, line)
                new_content = 
                ["<span class='string'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for digits
            Regex.match?(~r/^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/, line) -> 
                content = Regex.run(~r/^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/, line)
                new_content = 
                ["<span class='digit'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for reserved words
            Regex.match?(~r/^(true|false|null)/, line) -> 
                content = Regex.run(~r/^(true|false|null)/, line)
                new_content = 
                ["<span class='reserved-word'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
            
            # Look for spaces
            Regex.match?(~r/^\s/, line) -> 
                content = Regex.run(~r/^\s/, line)
                new_content = 
                ["<span class='reserved-word'>#{hd(content)}</span>"|new_content]
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
            
            true -> Enum.reverse(new_content)
        end
    end
    defp regex_tail("", new_content), do: new_content

    #Function that sums all prime numbers using parallelism
    def parallel_regex(fileList), 
        do: parallel_regex_rec(fileList, length(fileList), 
        div(Enum.count(fileList), length(fileList)), rem(Enum.count(fileList), 
        length(fileList)))

    #If range division results in an integer
    defp parallel_regex_rec(fileList, threads, range, 0) do
        0..(threads - 1)
        |>Enum.map(&Task.async(fn -> 
        Enum.map(&1 * range .. range * (&1 + 1) - 1, 
        fn x -> get_token_parallel(Enum.at(fileList, x), "index#{x}.html") end) end))
        |>Enum.map(&Task.await(&1, :infinity))
        #|> IO.inspect()
    end

    #If range division results in an integer
    defp parallel_regex_rec(fileList, threads, range, rem) do
        0..(threads - 1)
        |>Enum.map(&Task.async(fn -> 
        Enum.map(&1 * range .. range * (&1 + 1) - 1, 
        fn x -> get_token_parallel(Enum.at(fileList, x), "index#{x}.html") end) end))
        |>Enum.map(&Task.await(&1, :infinity))
        Enum.map(threads*range..threads*range-1+rem, 
        fn x -> get_token_parallel(Enum.at(fileList, x), "index#{x}.html") end)
        #
    end   
end 

#ParallelHighlighter.get_token_parallel("out_file_000002.json", "index.html")
#ParallelHighlighter.get_token_parallel("example_4.json", "index.html")
#ParallelHighlighter.parallel_regex(["example_0.json", "example_1.json", "example_2.json", "example_3.json", "example_4.json"], 2)
#ParallelHighlighter.parallel_regex(["out_file_000001.json", "out_file_000002.json", "out_file_000003.json"])