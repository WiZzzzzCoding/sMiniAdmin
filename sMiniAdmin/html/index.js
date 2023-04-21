const copyToClipboard = str => {
    const el = document.createElement('textarea');
    el.value = str;
    document.body.appendChild(el);
    el.select();
    document.execCommand('copy');
    document.body.removeChild(el);
};


$(function () {
    function display(bool) {
        if (bool) {
            $("#container").show();
        } else {
            $("#container").hide();
            $("#devcontent").hide();
        }
    }

    display(false)

    window.addEventListener('message', function(event) {
        var item = event.data;
        if (item.type === "ui") {
            if (item.status == true) {
                display(true)
            } else {
                display(false)
            }
        }
    })

    window.addEventListener('message', (event) => {
        if (event.data.type === 'clipboard') {
            copyToClipboard(event.data.data);
        }
    });
    
    // if the person uses the escape key, it will exit the resource
    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://sMiniAdmin/exit', JSON.stringify({}));
            return
        }
    };

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post('http://sMiniAdmin/exit', JSON.stringify({}));
            return
        }
    };
    $("#close").click(function () {
        $.post('http://sMiniAdmin/exit', JSON.stringify({}));
        return
    })




    $("#noclip").click(function () {
        $.post('http://sMiniAdmin/noclip', JSON.stringify({}));
        return
    })

    $("#tpm").click(function () {
        $.post('http://sMiniAdmin/tpm', JSON.stringify({}));
        return
    })

    $("#dev1").click(function () {
        $("#devcontent").show()     
        $("#container").hide()     
        $.post('http://sMiniAdmin/autrepage', JSON.stringify({}));
        return
    })

    $("#dev2").click(function () {
        $("#devcontent").hide()     
        $("#container").show()     
        $.post('http://sMiniAdmin/autrepage', JSON.stringify({}));
        return
    })

    $("#coords").click(function () {
        $.post('http://sMiniAdmin/coords', JSON.stringify({}));
        return
    })

    $("#bring").click(function () {
        $.post('http://sMiniAdmin/bring', JSON.stringify({}));
        return
    })

    $("#goto").click(function () {
        $.post('http://sMiniAdmin/goto', JSON.stringify({}));
        return
    })

    $("#freeze").click(function () {
        $.post('http://sMiniAdmin/freeze', JSON.stringify({}));
        return
    })

    $("#unfreeze").click(function () {
        $.post('http://sMiniAdmin/unfreeze', JSON.stringify({}));
        return
    })

})