$(function() {
    var categories = [];
    var names = [];
    var tabs = [];
    
    // create tab names and categories from result-list items
    $("#gene-list-results > li ").each(function() {
        categories.push($(this).attr("data-category"));
        names.push($(this).attr("data-name"));
    });

    // remove dups, sort
    categories = categories.filter(function(elem, pos, self) {
        return self.indexOf(elem) == pos; }).sort();

    names = names.filter(function(elem, pos, self) {
        return self.indexOf(elem) == pos; }).sort();

    $.each(categories, function(i, val){
        tabs.push({ label: names[i], category: val });
    });

    // watch for new tabs and attach tabs click event
    $("#gene-list-tabs > ul")
        .on("click", "li > a", function() {
            var tab_category = $(this).attr("data-category");

            // toggle active tab
            $("#gene-list-tabs > ul li").each(function() {
                var current_tab = $(this).find("a").attr("data-category");
                if(current_tab  == tab_category) { $(this).addClass("active"); }
                else { $(this).removeClass("active");  };
            });

            // filter list results
            $("#gene-list-results > li").each(function(i, val){
                var item_category = $(this).attr("data-category");
                if (tab_category == "all") { $(this).show();}
                else {
                    if (tab_category == item_category) { $(this).show(); }
                    else { $(this).hide(); } 
                }
            })
        });

    // create tabs
    $.each(tabs, function(i, val) {
        $("#gene-list-tabs > ul")
            .append('<li id="' + val.category + '">'
                    + '<a href="#" data-category="'
                    + val.category + '"><i class="icon-chevron-right"></i>'
                    + val.label
                    + '</a></li>');
    });
});