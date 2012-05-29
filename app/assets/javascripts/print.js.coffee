$(document).ready ->
    $('.print a').click (event) ->
        $('#print').hide('fast', -> 
            print()
            close()
        )