var scrollableElement, scrolloffset, scrolltiming;

scrolloffset = 0;

scrolltiming = 1000;

$(document).ready(function() {
  var filterPath, locationPath, scrollElem;
  filterPath = function(string) {
    string.replace(/^\//, '').replace(/(index|default).[a-zA-Z]{3,4}$/, '').replace(/\/$/, '');
    return string;
  };
  locationPath = filterPath(location.pathname);
  scrollElem = scrollableElement('html', 'body');
  return $('a[href*=#]').each(function() {
    var $target, target, targetOffset, thisPath;
    thisPath = filterPath(this.pathname) || locationPath;
    if (locationPath === thisPath && (location.hostname === this.hostname || !this.hostname) && this.hash.replace(/#/, '')) {
      $target = $(this.hash);
      target = this.hash;
      if (target) {
        targetOffset = $target.offset().top - scrolloffset;
        return $(this).click(function(event) {
          console.log("Click", scrollElem);
          event.preventDefault();
          return $(scrollElem).animate({
            scrollTop: targetOffset,
            ease: 'easeOut'
          }, scrolltiming, function() {
            return location.hash = target;
          });
        });
      }
    }
  });
});

scrollableElement = function(els) {
  var $scrollElement, el, i, isScrollable, _i, _len;
  for (_i = 0, _len = arguments.length; _i < _len; _i++) {
    i = arguments[_i];
    el = arguments[_i];
    $scrollElement = $(el);
    if ($scrollElement.scrollTop() > 0) {
      return el;
    } else {
      $scrollElement.scrollTop(1);
      isScrollable = $scrollElement.scrollTop() > 0;
      $scrollElement.scrollTop(0);
      if (isScrollable) return el;
    }
  }
  return [];
};