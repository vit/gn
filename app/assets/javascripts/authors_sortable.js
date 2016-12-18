//$(document).on('turbolinks:load', function() {

$(document).bind('turbolinks:load authorslistreload', function () {

    $(".authors-sortable").sortable({
        update: function( event, ui ) {
            var submission_id = $(this).data('submission');
            var lst = $(this).children();
            var nums = lst.map(function() {
                return $(this).data('n');
            }).toArray();
//            console.log(nums);

            var url = '/submissions/'+submission_id+'/update_authors.js';
            $.ajax(url, {
                method: "PUT",
                dataType: 'script',
                data: {
                    op: 'reorder_authors',
                    nums: nums
                }
            });

        }
    });

});
