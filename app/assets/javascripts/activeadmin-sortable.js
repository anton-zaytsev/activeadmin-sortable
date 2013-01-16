(function($) {
  $(document).ready(function() {
    var table = $('.handle').closest('table');

    $(window).on('resize.tablesort', function(){
      $('thead tr th', table).each(function(){
        $(this).width($(this).width());
      });
      $('tbody tr td', table).each(function(){
        $(this).width($(this).width());
      });
    }).trigger('resize.tablesort');

    $('tbody', table).activeAdminSortable();
  });

  $.fn.activeAdminSortable = function() {

    this.sortable({
      axis: 'y',
      cursor: "move",
      containment: "parent",
      tolerance: 'pointer',
      change: function(event, ui){
        tr = $(ui.item).closest('tbody').find('tr:not(.ui-sortable-helper)')
        tr.each(function(index, el){
          var $el = $(this);
          var klass = '',
              target = $el;
          if (index % 2 == 0) {
            klass = 'odd';
          }
          else {
            klass = 'even';
          }

          if ($el.hasClass('ui-sortable-placeholder')) {
            target = $el.siblings('.ui-sortable-helper');
          }

          target.removeClass('even odd').addClass(klass)
        });
        tr.filter(':even').removeClass('even odd').addClass('odd');
        tr.filter(':odd').removeClass('even odd').addClass('even');
      },
      handle: ".handle",
      update: function(event, ui) {
        var url = ui.item.find('[data-sort-url]').data('sort-url');
        var field = ui.item.find('[data-field]').data('field');

        var result = {};

        $(ui.item).parent().find('>tr').each(function(index, tr){
          result[$(tr).attr('id').match(/_(\d+)$/)[1]] = index;
        });

        $.ajax({
          url: url,
          type: 'post',
          data: {
            positions: result,
            field: field
          },
          success: function() {
            console.log('success')
//            window.location.reload()
          },
          error: function(){

          },
          complete: function(){

          }
        });
      }
    });

//    console.log(this.sortable( "option", "tolerance" ));

    this.disableSelection();
  }
})(jQuery);
