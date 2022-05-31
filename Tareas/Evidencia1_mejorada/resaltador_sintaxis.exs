defmodule Tfiles do
#Main function
    def json_html(in_filename, out_filename) do
        html =
        in_filename
        |> File.stream!()
        |> Enum.map(&String.split/1)
        |> Enum.join()
        |> IO.inspect()
        date = Date.utc_today()

        #Pre-written html template code
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
                
                #{html}
                </pre>
            </body>
            </html>"

        #Write the html index file
        File.write(out_filename, final_html)
        #File.write(out_filename, html)
    end

    def get_token(in_filename, out_filename) do
        token =
        in_filename
        |> File.stream!()
        |> Enum.join()
        #|> Enum.map(&regex/1)
        |> IO.inspect()
        date = Date.utc_today()
        final_token = regex(token)
        #IO.puts(regex(token))
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
        File.write(out_filename, final_html)
    end

    def regex(line), do: regex_tail(line, "")
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
        #Regex.run(~r/("\w*")(?=\s*:)/, line)
    end
    defp regex_tail("", new_content), do: new_content
end

Tfiles.get_token("example_5.json", "index.html")