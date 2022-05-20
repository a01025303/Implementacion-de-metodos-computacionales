# Code for syntax highlighter for a json file
#
# Andreina Sananez / A01024927
# Ana Paula Katsuda / A01025303
# 2022-05-18


defmodule Tfiles do
#Function that converts the json to html
    def json_html(in_filename, out_filename) do
        json_html =
        in_filename
        |> File.stream!() #read file and generate stream
        |> Enum.map(&regex/1) #apply regex function

        #get date
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
                <pre>#{json_html}
                </pre>
            </body>
            </html>"

        #Write the html index file
        File.write(out_filename, final_html)
    end

    #Regex evaluation function
    def regex(line) do
        cond do

        #digit
        Regex.run(~r/(?<=: )(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!.*")|(?<=:)(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!.*")/, line) != nil ->
            line = Regex.replace(~r/(?<=: )(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!.*")|(?<=:)(\+?\-?\d+\.?\d*E?e?\+?\-?\d*)(?!.*")/, 
            line, "<span class='digit'>\\0</span>")
            regex(line)

        #Object key
        Regex.run(~r/(".*")(?=\s*:)/, line) != nil ->
            line = Regex.replace(~r/(".*")(?=\s*:)/, line, 
            "<span class='object-key'>\\0</span>")
            regex(line)

        #Punctuation
        Regex.run(~r/({|}|(?<=\>)\s*:|,|\[|\])(?!<\/span>)/, line) != nil ->
            line = Regex.replace(~r/({|}|(?<=\>)\s*:|,|\[|\])(?!<\/span>)/, 
            line, "<span class='punctuation'>\\0</span>")
            regex(line)

        #String
        Regex.run(~r/("(\w+|\/+)\s?[^"]*")(?!<\/span>)|[""](?=<span )/, line) != nil ->
            line = Regex.replace(~r/("(\w+|\/+)\s?[^"]*")(?!<\/span>)|[""](?=<span )/, 
            line, "<span class='string'>\\0</span>")
            regex(line)

        #Reserved word
        Regex.run(~r/(true|false|null)(?=<span )/, line) != nil ->
            line = Regex.replace(~r/(true|false|null)(?=<span )/, 
            line, "<span class='reserved-word'>\\0</span>")
            regex(line)

        #Return final line
        true -> line

        end
    end
end

#Tfiles.json_html("example_0.json", "index.html")
