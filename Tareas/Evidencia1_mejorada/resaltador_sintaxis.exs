# Syntax Highlighter code
# Andreína Sanánez, A01024927
# Ana Paula Katsuda, A01025303

defmodule Tfiles do
    # Main function
    def get_token(in_filename, out_filename) do
        # Save read data in token
        token =
        # Read in file
        in_filename
        # Make it a stream
        |> File.stream!()
        # Turn into string using join
        |> Enum.join()
        #Inspector to see how file was read
        #|> IO.inspect()

        # Define current date
        date = Date.utc_today()
        # Save call to regex function using read file
        final_token = regex(token)
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
                    #{final_token}
                    </pre>
                </body>
                </html>"
        # Write the final html in out file
        File.write(out_filename, final_html)
    end

    # Definition of tail function to evaluate regex
    def regex(line), do: regex_tail(line, "")
    # Function that matches regex expressions for each token
    defp regex_tail(line, new_content) when line != "" do
        cond do
            # Look for punctuation
            Regex.match?(~r/^({|}|\s*:|,|\[|\])(?!<)/, line) -> 
                content = Regex.run(~r/^({|}|\s*:|,|\[|\])(?!<)/, line)
                new_content = "#{new_content}<span class='punctuation'>#{hd(content)}</span>"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            #Look for object key
            Regex.match?(~r/^("\w*.*")(?=\s*:)/, line) -> 
                content = Regex.run(~r/^("\w*.*")(?=\s*:)/, line)
                new_content = "#{new_content}<span class='object-key'>#{hd(content)}</span>"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for strings
            Regex.match?(~r/^("\w*\s?[^"]*")(?!:)/, line) -> 
                content = Regex.run(~r/^("\w*\s?[^"]*")(?!:)/, line)
                new_content = "#{new_content}<span class='string'>#{hd(content)}</span>"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for digits
            Regex.match?(~r/^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/, line) -> 
                content = Regex.run(~r/^-?(?:0|[1-9]\d*)(?:\.\d+)?(?:[eE][+-]?\d+)?/, line)
                new_content = "#{new_content}<span class='digit'>#{hd(content)}</span>"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
                
            # Look for reserved words
            Regex.match?(~r/^(true|false|null)/, line) -> 
                content = Regex.run(~r/^(true|false|null)/, line)
                new_content = "#{new_content}<span class='reserved-word'>#{hd(content)}</span>"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
            
            # Look for spaces
            Regex.match?(~r/^\s/, line) -> 
                content = Regex.run(~r/^\s/, line)
                new_content = "#{new_content}#{hd(content)}"
                content_length = String.length(hd(content))
                line = String.slice(line, content_length .. String.length(line))
                regex_tail(line, new_content)
            true -> new_content
        end
    end
    # Regex tail function for empty line
    defp regex_tail("", new_content), do: new_content
end

Tfiles.get_token("example_5.json", "index.html")