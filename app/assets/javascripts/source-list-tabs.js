$(function() {
    var categories = [];
    var names = [];
    var tabs = [];
    
    // create tab names and categories from result-list items
    $("#source-list-results > li ").each(function() {
        categories.push($(this).attr("data-category"));
        names.push($(this).attr("data-name"));
    });

    var dups = [];
    $.each(categories, function(i, val){
        if (dups.indexOf(val) == -1) { tabs.push({ label: names[i], category: val }); }
        dups.push(val);
    });

    tabs.sort(tabSort);

    // watch for new tabs and attach tabs click event
    $("#list-filter-tabs > ul")
        .on("click", "li > a", function() {
            var tab_category = $(this).attr("data-category");

            // toggle active tab
            $("#gene-list-tabs > ul li").each(function() {
                var current_tab = $(this).find("a").attr("data-category");
                if(current_tab  == tab_category) { $(this).addClass("active"); }
                else { $(this).removeClass("active");  };
            });

            // filter list results
            $("#source-list-results > li").each(function(i, val){
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
        $("#list-filter-tabs > ul")
            .append('<li class="' + val.category + '">'
                    + '<a href="#" data-category="'
                    + val.category + '"><i class="icon-chevron-right"></i>'
                    + val.label
                    + '</a></li>');
    });

    function tabSort(a,b) {
        if (a.label < b.label) { return -1; }
        if (a.label > b.label) { return  1; }
        return 0;
    }
});