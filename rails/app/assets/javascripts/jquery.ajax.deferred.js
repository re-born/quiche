(function($) {
/**
 * JSDeferred
 * Copyright (c) 2007 cho45 ( www.lowreal.net )
 *
 * http://coderepos.org/share/wiki/JSDeferred
 *
 * Version:: 0.2.2
 * License:: MIT
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */

  function Deferred () { return (this instanceof Deferred) ? this.init() : new Deferred() }
  Deferred.prototype = {
    init : function () {
      this._next    = null;
      this.callback = {
        ok: function (x) { return x },
        ng: function (x) { throw  x }
      };
      return this;
    },

    next  : function (fun) { return this._post("ok", fun) },
    error : function (fun) { return this._post("ng", fun) },
    call  : function (val) { return this._fire("ok", val) },
    fail  : function (err) { return this._fire("ng", err) },

    cancel : function () {
      (this.canceller || function () {})();
      return this.init();
    },

    _post : function (okng, fun) {
      this._next =  new Deferred();
      this._next.callback[okng] = fun;
      return this._next;
    },

    _fire : function (okng, value) {
      var next = "ok";
      try {
        value = this.callback[okng].call(this, value);
      } catch (e) {
        next  = "ng";
        value = e;
      }
      if (value instanceof Deferred) {
        value._next = this._next;
      } else {
        if (this._next) this._next._fire(next, value);
      }
      return this;
    }
  };

/**
 * Enhancing of jQuery.ajax with JSDeferred
 * http://developmentor.lrlab.to/
 *
 * Copyright(C) 2008 LEARNING RESOURCE LAB
 * http://friendfeed.com/nakajiman
 * http://hp.submit.ne.jp/d/16750/
 *
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
 */

  // _ajax
  $._ajax = $.ajax;

  // ajax
  $.ajax = function(s) {
    var deferred = new Deferred();
    $._ajax($.extend(true, {}, s, {
      success: function(data, textStatus) {
        if (s.success)
          s.success.apply(this, arguments);
        deferred.call(data);
      },
      error: function(xhr, status, e) {
        if (s.error)
          s.error.apply(this, arguments);
        deferred.fail(status || e);
      }
    }));
    return deferred;
  };

})(jQuery);
