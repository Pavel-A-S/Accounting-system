function toClipboard(e) {
  if ($(e.target).hasClass('copy-button')) {
    var text = $('#' + e.target.id + '_text');
    text.css('display','block');
    text.focus();
    text.select();
    document.execCommand('copy');
    text.css('display','none');
  } else if ($(e.target).hasClass('copy-button-glyphicon')) {
    var parent_id = $(e.target).parent().attr('id');
    var text = $('#' + parent_id + '_text');
    text.css('display','block');
    text.focus();
    text.select();
    document.execCommand('copy');
    text.css('display','none');
  }
}
