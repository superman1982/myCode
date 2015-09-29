//jquery.form.js start
/*!
 * jQuery Form Plugin
 * version: 3.51.0-2014.06.20
 * Requires jQuery v1.5 or later
 * Copyright (c) 2014 M. Alsup
 * Examples and documentation at: http://malsup.com/jquery/form/
 * Project repository: https://github.com/malsup/form
 * Dual licensed under the MIT and GPL licenses.
 * https://github.com/malsup/form#copyright-and-license
 */
/*global ActiveXObject */

// AMD support
(function (factory) {
    "use strict";
    if (typeof define === 'function' && define.amd) {
        // using AMD; register as anon module
        define(['jquery'], factory);
    } else {
        // no AMD; invoke directly
        factory( (typeof(jQuery) != 'undefined') ? jQuery : window.Zepto );
    }
}

(function($) {
"use strict";

/*
    Usage Note:
    -----------
    Do not use both ajaxSubmit and ajaxForm on the same form.  These
    functions are mutually exclusive.  Use ajaxSubmit if you want
    to bind your own submit handler to the form.  For example,

    $(document).ready(function() {
        $('#myForm').on('submit', function(e) {
            e.preventDefault(); // <-- important
            $(this).ajaxSubmit({
                target: '#output'
            });
        });
    });

    Use ajaxForm when you want the plugin to manage all the event binding
    for you.  For example,

    $(document).ready(function() {
        $('#myForm').ajaxForm({
            target: '#output'
        });
    });

    You can also use ajaxForm with delegation (requires jQuery v1.7+), so the
    form does not have to exist when you invoke ajaxForm:

    $('#myForm').ajaxForm({
        delegation: true,
        target: '#output'
    });

    When using ajaxForm, the ajaxSubmit function will be invoked for you
    at the appropriate time.
*/

/**
 * Feature detection
 */
var feature = {};
feature.fileapi = $("<input type='file'/>").get(0).files !== undefined;
feature.formdata = window.FormData !== undefined;

var hasProp = !!$.fn.prop;

// attr2 uses prop when it can but checks the return type for
// an expected string.  this accounts for the case where a form 
// contains inputs with names like "action" or "method"; in those
// cases "prop" returns the element
$.fn.attr2 = function() {
    if ( ! hasProp ) {
        return this.attr.apply(this, arguments);
    }
    var val = this.prop.apply(this, arguments);
    if ( ( val && val.jquery ) || typeof val === 'string' ) {
        return val;
    }
    return this.attr.apply(this, arguments);
};

/**
 * ajaxSubmit() provides a mechanism for immediately submitting
 * an HTML form using AJAX.
 */
$.fn.ajaxSubmit = function(options) {
    /*jshint scripturl:true */

    // fast fail if nothing selected (http://dev.jquery.com/ticket/2752)
    if (!this.length) {
        log('ajaxSubmit: skipping submit process - no element selected');
        return this;
    }

    var method, action, url, $form = this;

    if (typeof options == 'function') {
        options = { success: options };
    }
    else if ( options === undefined ) {
        options = {};
    }

    method = options.type || this.attr2('method');
    action = options.url  || this.attr2('action');

    url = (typeof action === 'string') ? $.trim(action) : '';
    url = url || window.location.href || '';
    if (url) {
        // clean url (don't include hash vaue)
        url = (url.match(/^([^#]+)/)||[])[1];
    }

    options = $.extend(true, {
        url:  url,
        success: $.ajaxSettings.success,
        type: method || $.ajaxSettings.type,
        iframeSrc: /^https/i.test(window.location.href || '') ? 'javascript:false' : 'about:blank'
    }, options);

    // hook for manipulating the form data before it is extracted;
    // convenient for use with rich editors like tinyMCE or FCKEditor
    var veto = {};
    this.trigger('form-pre-serialize', [this, options, veto]);
    if (veto.veto) {
        log('ajaxSubmit: submit vetoed via form-pre-serialize trigger');
        return this;
    }

    // provide opportunity to alter form data before it is serialized
    if (options.beforeSerialize && options.beforeSerialize(this, options) === false) {
        log('ajaxSubmit: submit aborted via beforeSerialize callback');
        return this;
    }

    var traditional = options.traditional;
    if ( traditional === undefined ) {
        traditional = $.ajaxSettings.traditional;
    }

    var elements = [];
    var qx, a = this.formToArray(options.semantic, elements);
    if (options.data) {
        options.extraData = options.data;
        qx = $.param(options.data, traditional);
    }

    // give pre-submit callback an opportunity to abort the submit
    if (options.beforeSubmit && options.beforeSubmit(a, this, options) === false) {
        log('ajaxSubmit: submit aborted via beforeSubmit callback');
        return this;
    }

    // fire vetoable 'validate' event
    this.trigger('form-submit-validate', [a, this, options, veto]);
    if (veto.veto) {
        log('ajaxSubmit: submit vetoed via form-submit-validate trigger');
        return this;
    }

    var q = $.param(a, traditional);
    if (qx) {
        q = ( q ? (q + '&' + qx) : qx );
    }
    if (options.type.toUpperCase() == 'GET') {
        options.url += (options.url.indexOf('?') >= 0 ? '&' : '?') + q;
        options.data = null;  // data is null for 'get'
    }
    else {
        options.data = q; // data is the query string for 'post'
    }

    var callbacks = [];
    if (options.resetForm) {
        callbacks.push(function() { $form.resetForm(); });
    }
    if (options.clearForm) {
        callbacks.push(function() { $form.clearForm(options.includeHidden); });
    }

    // perform a load on the target only if dataType is not provided
    if (!options.dataType && options.target) {
        var oldSuccess = options.success || function(){};
        callbacks.push(function(data) {
            var fn = options.replaceTarget ? 'replaceWith' : 'html';
            $(options.target)[fn](data).each(oldSuccess, arguments);
        });
    }
    else if (options.success) {
        callbacks.push(options.success);
    }

    options.success = function(data, status, xhr) { // jQuery 1.4+ passes xhr as 3rd arg
        var context = options.context || this ;    // jQuery 1.4+ supports scope context
        for (var i=0, max=callbacks.length; i < max; i++) {
            callbacks[i].apply(context, [data, status, xhr || $form, $form]);
        }
    };

    if (options.error) {
        var oldError = options.error;
        options.error = function(xhr, status, error) {
            var context = options.context || this;
            oldError.apply(context, [xhr, status, error, $form]);
        };
    }

     if (options.complete) {
        var oldComplete = options.complete;
        options.complete = function(xhr, status) {
            var context = options.context || this;
            oldComplete.apply(context, [xhr, status, $form]);
        };
    }

    // are there files to upload?

    // [value] (issue #113), also see comment:
    // https://github.com/malsup/form/commit/588306aedba1de01388032d5f42a60159eea9228#commitcomment-2180219
    var fileInputs = $('input[type=file]:enabled', this).filter(function() { return $(this).val() !== ''; });

    var hasFileInputs = fileInputs.length > 0;
    var mp = 'multipart/form-data';
    var multipart = ($form.attr('enctype') == mp || $form.attr('encoding') == mp);

    var fileAPI = feature.fileapi && feature.formdata;
    log("fileAPI :" + fileAPI);
    var shouldUseFrame = (hasFileInputs || multipart) && !fileAPI;

    var jqxhr;

    // options.iframe allows user to force iframe mode
    // 06-NOV-09: now defaulting to iframe mode if file input is detected
    if (options.iframe !== false && (options.iframe || shouldUseFrame)) {
        // hack to fix Safari hang (thanks to Tim Molendijk for this)
        // see:  http://groups.google.com/group/jquery-dev/browse_thread/thread/36395b7ab510dd5d
        if (options.closeKeepAlive) {
            $.get(options.closeKeepAlive, function() {
                jqxhr = fileUploadIframe(a);
            });
        }
        else {
            jqxhr = fileUploadIframe(a);
        }
    }
    else if ((hasFileInputs || multipart) && fileAPI) {
        jqxhr = fileUploadXhr(a);
    }
    else {
        jqxhr = $.ajax(options);
    }

    $form.removeData('jqxhr').data('jqxhr', jqxhr);

    // clear element array
    for (var k=0; k < elements.length; k++) {
        elements[k] = null;
    }

    // fire 'notify' event
    this.trigger('form-submit-notify', [this, options]);
    return this;

    // utility fn for deep serialization
    function deepSerialize(extraData){
        var serialized = $.param(extraData, options.traditional).split('&');
        var len = serialized.length;
        var result = [];
        var i, part;
        for (i=0; i < len; i++) {
            // #252; undo param space replacement
            serialized[i] = serialized[i].replace(/\+/g,' ');
            part = serialized[i].split('=');
            // #278; use array instead of object storage, favoring array serializations
            result.push([decodeURIComponent(part[0]), decodeURIComponent(part[1])]);
        }
        return result;
    }

     // XMLHttpRequest Level 2 file uploads (big hat tip to francois2metz)
    function fileUploadXhr(a) {
        var formdata = new FormData();

        for (var i=0; i < a.length; i++) {
            formdata.append(a[i].name, a[i].value);
        }

        if (options.extraData) {
            var serializedData = deepSerialize(options.extraData);
            for (i=0; i < serializedData.length; i++) {
                if (serializedData[i]) {
                    formdata.append(serializedData[i][0], serializedData[i][1]);
                }
            }
        }

        options.data = null;

        var s = $.extend(true, {}, $.ajaxSettings, options, {
            contentType: false,
            processData: false,
            cache: false,
            type: method || 'POST'
        });

        if (options.uploadProgress) {
            // workaround because jqXHR does not expose upload property
            s.xhr = function() {
                var xhr = $.ajaxSettings.xhr();
                if (xhr.upload) {
                    xhr.upload.addEventListener('progress', function(event) {
                        var percent = 0;
                        var position = event.loaded || event.position; /*event.position is deprecated*/
                        var total = event.total;
                        if (event.lengthComputable) {
                            percent = Math.ceil(position / total * 100);
                        }
                        options.uploadProgress(event, position, total, percent);
                    }, false);
                }
                return xhr;
            };
        }

        s.data = null;
        var beforeSend = s.beforeSend;
        s.beforeSend = function(xhr, o) {
            //Send FormData() provided by user
            if (options.formData) {
                o.data = options.formData;
            }
            else {
                o.data = formdata;
            }
            if(beforeSend) {
                beforeSend.call(this, xhr, o);
            }
        };
        return $.ajax(s);
    }

    // private function for handling file uploads (hat tip to YAHOO!)
    function fileUploadIframe(a) {
        var form = $form[0], el, i, s, g, id, $io, io, xhr, sub, n, timedOut, timeoutHandle;
        var deferred = $.Deferred();

        // #341
        deferred.abort = function(status) {
            xhr.abort(status);
        };

        if (a) {
            // ensure that every serialized input is still enabled
            for (i=0; i < elements.length; i++) {
                el = $(elements[i]);
                if ( hasProp ) {
                    el.prop('disabled', false);
                }
                else {
                    el.removeAttr('disabled');
                }
            }
        }

        s = $.extend(true, {}, $.ajaxSettings, options);
        s.context = s.context || s;
        id = 'jqFormIO' + (new Date().getTime());
        if (s.iframeTarget) {
            $io = $(s.iframeTarget);
            n = $io.attr2('name');
            if (!n) {
                $io.attr2('name', id);
            }
            else {
                id = n;
            }
        }
        else {
            $io = $('<iframe name="' + id + '" src="'+ s.iframeSrc +'" />');
            $io.css({ position: 'absolute', top: '-1000px', left: '-1000px' });
        }
        io = $io[0];


        xhr = { // mock object
            aborted: 0,
            responseText: null,
            responseXML: null,
            status: 0,
            statusText: 'n/a',
            getAllResponseHeaders: function() {},
            getResponseHeader: function() {},
            setRequestHeader: function() {},
            abort: function(status) {
                var e = (status === 'timeout' ? 'timeout' : 'aborted');
                log('aborting upload... ' + e);
                this.aborted = 1;

                try { // #214, #257
                    if (io.contentWindow.document.execCommand) {
                        io.contentWindow.document.execCommand('Stop');
                    }
                }
                catch(ignore) {}

                $io.attr('src', s.iframeSrc); // abort op in progress
                xhr.error = e;
                if (s.error) {
                    s.error.call(s.context, xhr, e, status);
                }
                if (g) {
                    $.event.trigger("ajaxError", [xhr, s, e]);
                }
                if (s.complete) {
                    s.complete.call(s.context, xhr, e);
                }
            }
        };

        g = s.global;
        // trigger ajax global events so that activity/block indicators work like normal
        if (g && 0 === $.active++) {
            $.event.trigger("ajaxStart");
        }
        if (g) {
            $.event.trigger("ajaxSend", [xhr, s]);
        }

        if (s.beforeSend && s.beforeSend.call(s.context, xhr, s) === false) {
            if (s.global) {
                $.active--;
            }
            deferred.reject();
            return deferred;
        }
        if (xhr.aborted) {
            deferred.reject();
            return deferred;
        }

        // add submitting element to data if we know it
        sub = form.clk;
        if (sub) {
            n = sub.name;
            if (n && !sub.disabled) {
                s.extraData = s.extraData || {};
                s.extraData[n] = sub.value;
                if (sub.type == "image") {
                    s.extraData[n+'.x'] = form.clk_x;
                    s.extraData[n+'.y'] = form.clk_y;
                }
            }
        }

        var CLIENT_TIMEOUT_ABORT = 1;
        var SERVER_ABORT = 2;
                
        function getDoc(frame) {
            /* it looks like contentWindow or contentDocument do not
             * carry the protocol property in ie8, when running under ssl
             * frame.document is the only valid response document, since
             * the protocol is know but not on the other two objects. strange?
             * "Same origin policy" http://en.wikipedia.org/wiki/Same_origin_policy
             */
            
            var doc = null;
            
            // IE8 cascading access check
            try {
                if (frame.contentWindow) {
                    doc = frame.contentWindow.document;
                }
            } catch(err) {
                // IE8 access denied under ssl & missing protocol
                log('cannot get iframe.contentWindow document: ' + err);
            }

            if (doc) { // successful getting content
                return doc;
            }

            try { // simply checking may throw in ie8 under ssl or mismatched protocol
                doc = frame.contentDocument ? frame.contentDocument : frame.document;
            } catch(err) {
                // last attempt
                log('cannot get iframe.contentDocument: ' + err);
                doc = frame.document;
            }
            return doc;
        }

        // Rails CSRF hack (thanks to Yvan Barthelemy)
        var csrf_token = $('meta[name=csrf-token]').attr('content');
        var csrf_param = $('meta[name=csrf-param]').attr('content');
        if (csrf_param && csrf_token) {
            s.extraData = s.extraData || {};
            s.extraData[csrf_param] = csrf_token;
        }

        // take a breath so that pending repaints get some cpu time before the upload starts
        function doSubmit() {
            // make sure form attrs are set
            var t = $form.attr2('target'), 
                a = $form.attr2('action'), 
                mp = 'multipart/form-data',
                et = $form.attr('enctype') || $form.attr('encoding') || mp;

            // update form attrs in IE friendly way
            form.setAttribute('target',id);
            if (!method || /post/i.test(method) ) {
                form.setAttribute('method', 'POST');
            }
            if (a != s.url) {
                form.setAttribute('action', s.url);
            }

            // ie borks in some cases when setting encoding
            if (! s.skipEncodingOverride && (!method || /post/i.test(method))) {
                $form.attr({
                    encoding: 'multipart/form-data',
                    enctype:  'multipart/form-data'
                });
            }

            // support timout
            if (s.timeout) {
                timeoutHandle = setTimeout(function() { timedOut = true; cb(CLIENT_TIMEOUT_ABORT); }, s.timeout);
            }

            // look for server aborts
            function checkState() {
                try {
                    var state = getDoc(io).readyState;
                    log('state = ' + state);
                    if (state && state.toLowerCase() == 'uninitialized') {
                        setTimeout(checkState,50);
                    }
                }
                catch(e) {
                    log('Server abort: ' , e, ' (', e.name, ')');
                    cb(SERVER_ABORT);
                    if (timeoutHandle) {
                        clearTimeout(timeoutHandle);
                    }
                    timeoutHandle = undefined;
                }
            }

            // add "extra" data to form if provided in options
            var extraInputs = [];
            try {
                if (s.extraData) {
                    for (var n in s.extraData) {
                        if (s.extraData.hasOwnProperty(n)) {
                           // if using the $.param format that allows for multiple values with the same name
                           if($.isPlainObject(s.extraData[n]) && s.extraData[n].hasOwnProperty('name') && s.extraData[n].hasOwnProperty('value')) {
                               extraInputs.push(
                               $('<input type="hidden" name="'+s.extraData[n].name+'">').val(s.extraData[n].value)
                                   .appendTo(form)[0]);
                           } else {
                               extraInputs.push(
                               $('<input type="hidden" name="'+n+'">').val(s.extraData[n])
                                   .appendTo(form)[0]);
                           }
                        }
                    }
                }

                if (!s.iframeTarget) {
                    // add iframe to doc and submit the form
                    $io.appendTo('body');
                }
                if (io.attachEvent) {
                    io.attachEvent('onload', cb);
                }
                else {
                    io.addEventListener('load', cb, false);
                }
                setTimeout(checkState,15);

                try {
                    form.submit();
                } catch(err) {
                    // just in case form has element with name/id of 'submit'
                    var submitFn = document.createElement('form').submit;
                    submitFn.apply(form);
                }
            }
            finally {
                // reset attrs and remove "extra" input elements
                form.setAttribute('action',a);
                form.setAttribute('enctype', et); // #380
                if(t) {
                    form.setAttribute('target', t);
                } else {
                    $form.removeAttr('target');
                }
                $(extraInputs).remove();
            }
        }

        if (s.forceSync) {
            doSubmit();
        }
        else {
            setTimeout(doSubmit, 10); // this lets dom updates render
        }

        var data, doc, domCheckCount = 50, callbackProcessed;

        function cb(e) {
            if (xhr.aborted || callbackProcessed) {
                return;
            }
            
            doc = getDoc(io);
            if(!doc) {
                log('cannot access response document');
                e = SERVER_ABORT;
            }
            if (e === CLIENT_TIMEOUT_ABORT && xhr) {
                xhr.abort('timeout');
                deferred.reject(xhr, 'timeout');
                return;
            }
            else if (e == SERVER_ABORT && xhr) {
                xhr.abort('server abort');
                deferred.reject(xhr, 'error', 'server abort');
                return;
            }

            if (!doc || doc.location.href == s.iframeSrc) {
                // response not received yet
                if (!timedOut) {
                    return;
                }
            }
            if (io.detachEvent) {
                io.detachEvent('onload', cb);
            }
            else {
                io.removeEventListener('load', cb, false);
            }

            var status = 'success', errMsg;
            try {
                if (timedOut) {
                    throw 'timeout';
                }

                var isXml = s.dataType == 'xml' || doc.XMLDocument || $.isXMLDoc(doc);
                log('isXml='+isXml);
                if (!isXml && window.opera && (doc.body === null || !doc.body.innerHTML)) {
                    if (--domCheckCount) {
                        // in some browsers (Opera) the iframe DOM is not always traversable when
                        // the onload callback fires, so we loop a bit to accommodate
                        log('requeing onLoad callback, DOM not available');
                        setTimeout(cb, 250);
                        return;
                    }
                    // let this fall through because server response could be an empty document
                    //log('Could not access iframe DOM after mutiple tries.');
                    //throw 'DOMException: not available';
                }

                //log('response detected');
                var docRoot = doc.body ? doc.body : doc.documentElement;
                xhr.responseText = docRoot ? docRoot.innerHTML : null;
                xhr.responseXML = doc.XMLDocument ? doc.XMLDocument : doc;
                if (isXml) {
                    s.dataType = 'xml';
                }
                xhr.getResponseHeader = function(header){
                    var headers = {'content-type': s.dataType};
                    return headers[header.toLowerCase()];
                };
                // support for XHR 'status' & 'statusText' emulation :
                if (docRoot) {
                    xhr.status = Number( docRoot.getAttribute('status') ) || xhr.status;
                    xhr.statusText = docRoot.getAttribute('statusText') || xhr.statusText;
                }

                var dt = (s.dataType || '').toLowerCase();
                var scr = /(json|script|text)/.test(dt);
                if (scr || s.textarea) {
                    // see if user embedded response in textarea
                    var ta = doc.getElementsByTagName('textarea')[0];
                    if (ta) {
                        xhr.responseText = ta.value;
                        // support for XHR 'status' & 'statusText' emulation :
                        xhr.status = Number( ta.getAttribute('status') ) || xhr.status;
                        xhr.statusText = ta.getAttribute('statusText') || xhr.statusText;
                    }
                    else if (scr) {
                        // account for browsers injecting pre around json response
                        var pre = doc.getElementsByTagName('pre')[0];
                        var b = doc.getElementsByTagName('body')[0];
                        if (pre) {
                            xhr.responseText = pre.textContent ? pre.textContent : pre.innerText;
                        }
                        else if (b) {
                            xhr.responseText = b.textContent ? b.textContent : b.innerText;
                        }
                    }
                }
                else if (dt == 'xml' && !xhr.responseXML && xhr.responseText) {
                    xhr.responseXML = toXml(xhr.responseText);
                }

                try {
                    data = httpData(xhr, dt, s);
                }
                catch (err) {
                    status = 'parsererror';
                    xhr.error = errMsg = (err || status);
                }
            }
            catch (err) {
                log('error caught: ',err);
                status = 'error';
                xhr.error = errMsg = (err || status);
            }

            if (xhr.aborted) {
                log('upload aborted');
                status = null;
            }

            if (xhr.status) { // we've set xhr.status
                status = (xhr.status >= 200 && xhr.status < 300 || xhr.status === 304) ? 'success' : 'error';
            }

            // ordering of these callbacks/triggers is odd, but that's how $.ajax does it
            if (status === 'success') {
                if (s.success) {
                    s.success.call(s.context, data, 'success', xhr);
                }
                deferred.resolve(xhr.responseText, 'success', xhr);
                if (g) {
                    $.event.trigger("ajaxSuccess", [xhr, s]);
                }
            }
            else if (status) {
                if (errMsg === undefined) {
                    errMsg = xhr.statusText;
                }
                if (s.error) {
                    s.error.call(s.context, xhr, status, errMsg);
                }
                deferred.reject(xhr, 'error', errMsg);
                if (g) {
                    $.event.trigger("ajaxError", [xhr, s, errMsg]);
                }
            }

            if (g) {
                $.event.trigger("ajaxComplete", [xhr, s]);
            }

            if (g && ! --$.active) {
                $.event.trigger("ajaxStop");
            }

            if (s.complete) {
                s.complete.call(s.context, xhr, status);
            }

            callbackProcessed = true;
            if (s.timeout) {
                clearTimeout(timeoutHandle);
            }

            // clean up
            setTimeout(function() {
                if (!s.iframeTarget) {
                    $io.remove();
                }
                else { //adding else to clean up existing iframe response.
                    $io.attr('src', s.iframeSrc);
                }
                xhr.responseXML = null;
            }, 100);
        }

        var toXml = $.parseXML || function(s, doc) { // use parseXML if available (jQuery 1.5+)
            if (window.ActiveXObject) {
                doc = new ActiveXObject('Microsoft.XMLDOM');
                doc.async = 'false';
                doc.loadXML(s);
            }
            else {
                doc = (new DOMParser()).parseFromString(s, 'text/xml');
            }
            return (doc && doc.documentElement && doc.documentElement.nodeName != 'parsererror') ? doc : null;
        };
        var parseJSON = $.parseJSON || function(s) {
            /*jslint evil:true */
            return window['eval']('(' + s + ')');
        };

        var httpData = function( xhr, type, s ) { // mostly lifted from jq1.4.4

            var ct = xhr.getResponseHeader('content-type') || '',
                xml = type === 'xml' || !type && ct.indexOf('xml') >= 0,
                data = xml ? xhr.responseXML : xhr.responseText;

            if (xml && data.documentElement.nodeName === 'parsererror') {
                if ($.error) {
                    $.error('parsererror');
                }
            }
            if (s && s.dataFilter) {
                data = s.dataFilter(data, type);
            }
            if (typeof data === 'string') {
                if (type === 'json' || !type && ct.indexOf('json') >= 0) {
                    data = parseJSON(data);
                } else if (type === "script" || !type && ct.indexOf("javascript") >= 0) {
                    $.globalEval(data);
                }
            }
            return data;
        };

        return deferred;
    }
};

/**
 * ajaxForm() provides a mechanism for fully automating form submission.
 *
 * The advantages of using this method instead of ajaxSubmit() are:
 *
 * 1: This method will include coordinates for <input type="image" /> elements (if the element
 *    is used to submit the form).
 * 2. This method will include the submit element's name/value data (for the element that was
 *    used to submit the form).
 * 3. This method binds the submit() method to the form for you.
 *
 * The options argument for ajaxForm works exactly as it does for ajaxSubmit.  ajaxForm merely
 * passes the options argument along after properly binding events for submit elements and
 * the form itself.
 */
$.fn.ajaxForm = function(options) {
    options = options || {};
    options.delegation = options.delegation && $.isFunction($.fn.on);

    // in jQuery 1.3+ we can fix mistakes with the ready state
    if (!options.delegation && this.length === 0) {
        var o = { s: this.selector, c: this.context };
        if (!$.isReady && o.s) {
            log('DOM not ready, queuing ajaxForm');
            $(function() {
                $(o.s,o.c).ajaxForm(options);
            });
            return this;
        }
        // is your DOM ready?  http://docs.jquery.com/Tutorials:Introducing_$(document).ready()
        log('terminating; zero elements found by selector' + ($.isReady ? '' : ' (DOM not ready)'));
        return this;
    }

    if ( options.delegation ) {
        $(document)
            .off('submit.form-plugin', this.selector, doAjaxSubmit)
            .off('click.form-plugin', this.selector, captureSubmittingElement)
            .on('submit.form-plugin', this.selector, options, doAjaxSubmit)
            .on('click.form-plugin', this.selector, options, captureSubmittingElement);
        return this;
    }

    return this.ajaxFormUnbind()
        .bind('submit.form-plugin', options, doAjaxSubmit)
        .bind('click.form-plugin', options, captureSubmittingElement);
};

// private event handlers
function doAjaxSubmit(e) {
    /*jshint validthis:true */
    var options = e.data;
    if (!e.isDefaultPrevented()) { // if event has been canceled, don't proceed
        e.preventDefault();
        $(e.target).ajaxSubmit(options); // #365
    }
}

function captureSubmittingElement(e) {
    /*jshint validthis:true */
    var target = e.target;
    var $el = $(target);
    if (!($el.is("[type=submit],[type=image]"))) {
        // is this a child element of the submit el?  (ex: a span within a button)
        var t = $el.closest('[type=submit]');
        if (t.length === 0) {
            return;
        }
        target = t[0];
    }
    var form = this;
    form.clk = target;
    if (target.type == 'image') {
        if (e.offsetX !== undefined) {
            form.clk_x = e.offsetX;
            form.clk_y = e.offsetY;
        } else if (typeof $.fn.offset == 'function') {
            var offset = $el.offset();
            form.clk_x = e.pageX - offset.left;
            form.clk_y = e.pageY - offset.top;
        } else {
            form.clk_x = e.pageX - target.offsetLeft;
            form.clk_y = e.pageY - target.offsetTop;
        }
    }
    // clear form vars
    setTimeout(function() { form.clk = form.clk_x = form.clk_y = null; }, 100);
}


// ajaxFormUnbind unbinds the event handlers that were bound by ajaxForm
$.fn.ajaxFormUnbind = function() {
    return this.unbind('submit.form-plugin click.form-plugin');
};

/**
 * formToArray() gathers form element data into an array of objects that can
 * be passed to any of the following ajax functions: $.get, $.post, or load.
 * Each object in the array has both a 'name' and 'value' property.  An example of
 * an array for a simple login form might be:
 *
 * [ { name: 'username', value: 'jresig' }, { name: 'password', value: 'secret' } ]
 *
 * It is this array that is passed to pre-submit callback functions provided to the
 * ajaxSubmit() and ajaxForm() methods.
 */
$.fn.formToArray = function(semantic, elements) {
    var a = [];
    if (this.length === 0) {
        return a;
    }

    var form = this[0];
    var formId = this.attr('id');
    var els = semantic ? form.getElementsByTagName('*') : form.elements;
    var els2;

    if (els && !/MSIE [678]/.test(navigator.userAgent)) { // #390
        els = $(els).get();  // convert to standard array
    }

    // #386; account for inputs outside the form which use the 'form' attribute
    if ( formId ) {
        els2 = $(':input[form="' + formId + '"]').get(); // hat tip @thet
        if ( els2.length ) {
            els = (els || []).concat(els2);
        }
    }

    if (!els || !els.length) {
        return a;
    }

    var i,j,n,v,el,max,jmax;
    for(i=0, max=els.length; i < max; i++) {
        el = els[i];
        n = el.name;
        if (!n || el.disabled) {
            continue;
        }

        if (semantic && form.clk && el.type == "image") {
            // handle image inputs on the fly when semantic == true
            if(form.clk == el) {
                a.push({name: n, value: $(el).val(), type: el.type });
                a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
            }
            continue;
        }

        v = $.fieldValue(el, true);
        if (v && v.constructor == Array) {
            if (elements) {
                elements.push(el);
            }
            for(j=0, jmax=v.length; j < jmax; j++) {
                a.push({name: n, value: v[j]});
            }
        }
        else if (feature.fileapi && el.type == 'file') {
            if (elements) {
                elements.push(el);
            }
            var files = el.files;
            if (files.length) {
                for (j=0; j < files.length; j++) {
                    a.push({name: n, value: files[j], type: el.type});
                }
            }
            else {
                // #180
                a.push({ name: n, value: '', type: el.type });
            }
        }
        else if (v !== null && typeof v != 'undefined') {
            if (elements) {
                elements.push(el);
            }
            a.push({name: n, value: v, type: el.type, required: el.required});
        }
    }

    if (!semantic && form.clk) {
        // input type=='image' are not found in elements array! handle it here
        var $input = $(form.clk), input = $input[0];
        n = input.name;
        if (n && !input.disabled && input.type == 'image') {
            a.push({name: n, value: $input.val()});
            a.push({name: n+'.x', value: form.clk_x}, {name: n+'.y', value: form.clk_y});
        }
    }
    return a;
};

/**
 * Serializes form data into a 'submittable' string. This method will return a string
 * in the format: name1=value1&amp;name2=value2
 */
$.fn.formSerialize = function(semantic) {
    //hand off to jQuery.param for proper encoding
    return $.param(this.formToArray(semantic));
};

/**
 * Serializes all field elements in the jQuery object into a query string.
 * This method will return a string in the format: name1=value1&amp;name2=value2
 */
$.fn.fieldSerialize = function(successful) {
    var a = [];
    this.each(function() {
        var n = this.name;
        if (!n) {
            return;
        }
        var v = $.fieldValue(this, successful);
        if (v && v.constructor == Array) {
            for (var i=0,max=v.length; i < max; i++) {
                a.push({name: n, value: v[i]});
            }
        }
        else if (v !== null && typeof v != 'undefined') {
            a.push({name: this.name, value: v});
        }
    });
    //hand off to jQuery.param for proper encoding
    return $.param(a);
};

/**
 * Returns the value(s) of the element in the matched set.  For example, consider the following form:
 *
 *  <form><fieldset>
 *      <input name="A" type="text" />
 *      <input name="A" type="text" />
 *      <input name="B" type="checkbox" value="B1" />
 *      <input name="B" type="checkbox" value="B2"/>
 *      <input name="C" type="radio" value="C1" />
 *      <input name="C" type="radio" value="C2" />
 *  </fieldset></form>
 *
 *  var v = $('input[type=text]').fieldValue();
 *  // if no values are entered into the text inputs
 *  v == ['','']
 *  // if values entered into the text inputs are 'foo' and 'bar'
 *  v == ['foo','bar']
 *
 *  var v = $('input[type=checkbox]').fieldValue();
 *  // if neither checkbox is checked
 *  v === undefined
 *  // if both checkboxes are checked
 *  v == ['B1', 'B2']
 *
 *  var v = $('input[type=radio]').fieldValue();
 *  // if neither radio is checked
 *  v === undefined
 *  // if first radio is checked
 *  v == ['C1']
 *
 * The successful argument controls whether or not the field element must be 'successful'
 * (per http://www.w3.org/TR/html4/interact/forms.html#successful-controls).
 * The default value of the successful argument is true.  If this value is false the value(s)
 * for each element is returned.
 *
 * Note: This method *always* returns an array.  If no valid value can be determined the
 *    array will be empty, otherwise it will contain one or more values.
 */
$.fn.fieldValue = function(successful) {
    for (var val=[], i=0, max=this.length; i < max; i++) {
        var el = this[i];
        var v = $.fieldValue(el, successful);
        if (v === null || typeof v == 'undefined' || (v.constructor == Array && !v.length)) {
            continue;
        }
        if (v.constructor == Array) {
            $.merge(val, v);
        }
        else {
            val.push(v);
        }
    }
    return val;
};

/**
 * Returns the value of the field element.
 */
$.fieldValue = function(el, successful) {
    var n = el.name, t = el.type, tag = el.tagName.toLowerCase();
    if (successful === undefined) {
        successful = true;
    }

    if (successful && (!n || el.disabled || t == 'reset' || t == 'button' ||
        (t == 'checkbox' || t == 'radio') && !el.checked ||
        (t == 'submit' || t == 'image') && el.form && el.form.clk != el ||
        tag == 'select' && el.selectedIndex == -1)) {
            return null;
    }

    if (tag == 'select') {
        var index = el.selectedIndex;
        if (index < 0) {
            return null;
        }
        var a = [], ops = el.options;
        var one = (t == 'select-one');
        var max = (one ? index+1 : ops.length);
        for(var i=(one ? index : 0); i < max; i++) {
            var op = ops[i];
            if (op.selected) {
                var v = op.value;
                if (!v) { // extra pain for IE...
                    v = (op.attributes && op.attributes.value && !(op.attributes.value.specified)) ? op.text : op.value;
                }
                if (one) {
                    return v;
                }
                a.push(v);
            }
        }
        return a;
    }
    return $(el).val();
};

/**
 * Clears the form data.  Takes the following actions on the form's input fields:
 *  - input text fields will have their 'value' property set to the empty string
 *  - select elements will have their 'selectedIndex' property set to -1
 *  - checkbox and radio inputs will have their 'checked' property set to false
 *  - inputs of type submit, button, reset, and hidden will *not* be effected
 *  - button elements will *not* be effected
 */
$.fn.clearForm = function(includeHidden) {
    return this.each(function() {
        $('input,select,textarea', this).clearFields(includeHidden);
    });
};

/**
 * Clears the selected form elements.
 */
$.fn.clearFields = $.fn.clearInputs = function(includeHidden) {
    var re = /^(?:color|date|datetime|email|month|number|password|range|search|tel|text|time|url|week)$/i; // 'hidden' is not in this list
    return this.each(function() {
        var t = this.type, tag = this.tagName.toLowerCase();
        if (re.test(t) || tag == 'textarea') {
            this.value = '';
        }
        else if (t == 'checkbox' || t == 'radio') {
            this.checked = false;
        }
        else if (tag == 'select') {
            this.selectedIndex = -1;
        }
        else if (t == "file") {
            if (/MSIE/.test(navigator.userAgent)) {
                $(this).replaceWith($(this).clone(true));
            } else {
                $(this).val('');
            }
        }
        else if (includeHidden) {
            // includeHidden can be the value true, or it can be a selector string
            // indicating a special test; for example:
            //  $('#myForm').clearForm('.special:hidden')
            // the above would clean hidden inputs that have the class of 'special'
            if ( (includeHidden === true && /hidden/.test(t)) ||
                 (typeof includeHidden == 'string' && $(this).is(includeHidden)) ) {
                this.value = '';
            }
        }
    });
};

/**
 * Resets the form data.  Causes all form elements to be reset to their original value.
 */
$.fn.resetForm = function() {
    return this.each(function() {
        // guard against an input with the name of 'reset'
        // note that IE reports the reset function as an 'object'
        if (typeof this.reset == 'function' || (typeof this.reset == 'object' && !this.reset.nodeType)) {
            this.reset();
        }
    });
};

/**
 * Enables or disables any matching elements.
 */
$.fn.enable = function(b) {
    if (b === undefined) {
        b = true;
    }
    return this.each(function() {
        this.disabled = !b;
    });
};

/**
 * Checks/unchecks any matching checkboxes or radio buttons and
 * selects/deselects and matching option elements.
 */
$.fn.selected = function(select) {
    if (select === undefined) {
        select = true;
    }
    return this.each(function() {
        var t = this.type;
        if (t == 'checkbox' || t == 'radio') {
            this.checked = select;
        }
        else if (this.tagName.toLowerCase() == 'option') {
            var $sel = $(this).parent('select');
            if (select && $sel[0] && $sel[0].type == 'select-one') {
                // deselect all other options
                $sel.find('option').selected(false);
            }
            this.selected = select;
        }
    });
};

// expose debug var
$.fn.ajaxSubmit.debug = false;

// helper fn for console logging
function log() {
    if (!$.fn.ajaxSubmit.debug) {
        return;
    }
    var msg = '[jquery.form] ' + Array.prototype.join.call(arguments,'');
    if (window.console && window.console.log) {
        window.console.log(msg);
    }
    else if (window.opera && window.opera.postError) {
        window.opera.postError(msg);
    }
}

}));
//jquery.form.js end
//jquery.i18n.properties.js start
/******************************************************************************
 * jquery.i18n.properties
 *
 * Dual licensed under the GPL (http://dev.jquery.com/browser/trunk/jquery/GPL-LICENSE.txt) and
 * MIT (http://dev.jquery.com/browser/trunk/jquery/MIT-LICENSE.txt) licenses.
 *
 * @version     1.1.x
 * @author      Nuno Fernandes
 *              Matthew Lohbihler
 * @url         www.codingwithcoffee.com
 * @inspiration Localisation assistance for jQuery (http://keith-wood.name/localisation.html)
 *              by Keith Wood (kbwood{at}iinet.com.au) June 2007
 *
 *****************************************************************************/

(function($) {

if(!$.i18n) $.i18n = {};

/** Map holding bundle keys (if mode: 'map') */
$.i18n.map = {};

/**
 * Load and parse message bundle files (.properties),
 * making bundles keys available as javascript variables.
 *
 * i18n files are named <name>.js, or <name>_<language>.js or <name>_<language>_<country>.js
 * Where:
 *      The <language> argument is a valid ISO Language Code. These codes are the lower-case,
 *      two-letter codes as defined by ISO-639. You can find a full list of these codes at a
 *      number of sites, such as: http://www.loc.gov/standards/iso639-2/englangn.html
 *      The <country> argument is a valid ISO Country Code. These codes are the upper-case,
 *      two-letter codes as defined by ISO-3166. You can find a full list of these codes at a
 *      number of sites, such as: http://www.iso.ch/iso/en/prods-services/iso3166ma/02iso-3166-code-lists/list-en1.html
 *
 * Sample usage for a bundles/Messages.properties bundle:
 * $.i18n.properties({
 *      name:      'Messages',
 *      language:  'en_US',
 *      path:      'bundles'
 * });
 * @param  name			(string/string[], optional) names of file to load (eg, 'Messages' or ['Msg1','Msg2']). Defaults to "Messages"
 * @param  language		(string, optional) language/country code (eg, 'en', 'en_US', 'pt_PT'). if not specified, language reported by the browser will be used instead.
 * @param  path			(string, optional) path of directory that contains file to load
 * @param  mode			(string, optional) whether bundles keys are available as JavaScript variables/functions or as a map (eg, 'vars' or 'map')
 * @param  cache        (boolean, optional) whether bundles should be cached by the browser, or forcibly reloaded on each page load. Defaults to false (i.e. forcibly reloaded)
 * @param  encoding 	(string, optional) the encoding to request for bundles. Property file resource bundles are specified to be in ISO-8859-1 format. Defaults to UTF-8 for backward compatibility.
 * @param  callback     (function, optional) callback function to be called after script is terminated
 */
$.i18n.properties = function(settings) {
	// set up settings
    var defaults = {
        name:           'Messages',
        language:       '',
        path:           '',
        mode:           'vars',
        cache:			false,
        encoding:       'UTF-8',
        callback:       null
    };
    settings = $.extend(defaults, settings);
    if(settings.language === null || settings.language == '') {
	   settings.language = $.i18n.browserLang();
	}
	if(settings.language === null) {settings.language='';}

	// load and parse bundle files
	var files = getFiles(settings.name);
	for(i=0; i<files.length; i++) {
        // 3. with language code and country code (eg, Messages_pt_PT.properties)
        if(settings.language.length >= 5) {
            loadAndParseFile(settings.path + files[i] + '_' + settings.language.substring(0, 5) +'.properties', settings);
            continue;
        }
        // 2. with language code (eg, Messages_pt.properties)
        if(settings.language.length >= 2) {
            loadAndParseFile(settings.path + files[i] + '_' + settings.language.substring(0, 2) +'.properties', settings);
            continue;
        }
		// 1. load base (eg, Messages.properties)
		loadAndParseFile(settings.path + files[i] + '.properties', settings);
	}

	// call callback
	if(settings.callback){ settings.callback(); }
};


/**
 * When configured with mode: 'map', allows access to bundle values by specifying its key.
 * Eg, jQuery.i18n.prop('com.company.bundles.menu_add')
 */
$.i18n.prop = function(key /* Add parameters as function arguments as necessary  */) {
	var value = $.i18n.map[key];
	if (value == null)
		return key;

	var phvList;
	if (arguments.length == 2 && $.isArray(arguments[1]))
		// An array was passed as the only parameter, so assume it is the list of place holder values.
		phvList = arguments[1];

	// Place holder replacement
	/**
	 * Tested with:
	 *   test.t1=asdf ''{0}''
	 *   test.t2=asdf '{0}' '{1}'{1}'zxcv
	 *   test.t3=This is \"a quote" 'a''{0}''s'd{fgh{ij'
	 *   test.t4="'''{'0}''" {0}{a}
	 *   test.t5="'''{0}'''" {1}
	 *   test.t6=a {1} b {0} c
	 *   test.t7=a 'quoted \\ s\ttringy' \t\t x
	 *
	 * Produces:
	 *   test.t1, p1 ==> asdf 'p1'
	 *   test.t2, p1 ==> asdf {0} {1}{1}zxcv
	 *   test.t3, p1 ==> This is "a quote" a'{0}'sd{fgh{ij
	 *   test.t4, p1 ==> "'{0}'" p1{a}
	 *   test.t5, p1 ==> "'{0}'" {1}
	 *   test.t6, p1 ==> a {1} b p1 c
	 *   test.t6, p1, p2 ==> a p2 b p1 c
	 *   test.t6, p1, p2, p3 ==> a p2 b p1 c
	 *   test.t7 ==> a quoted \ s	tringy 		 x
	 */

	var i;
	if (typeof(value) == 'string') {
        // Handle escape characters. Done separately from the tokenizing loop below because escape characters are
		// active in quoted strings.
        i = 0;
        while ((i = value.indexOf('\\', i)) != -1) {
 		    if (value.charAt(i+1) == 't')
 			    value = value.substring(0, i) + '\t' + value.substring((i++) + 2); // tab
 		    else if (value.charAt(i+1) == 'r')
 			    value = value.substring(0, i) + '\r' + value.substring((i++) + 2); // return
 		    else if (value.charAt(i+1) == 'n')
 			    value = value.substring(0, i) + '\n' + value.substring((i++) + 2); // line feed
 		    else if (value.charAt(i+1) == 'f')
 			    value = value.substring(0, i) + '\f' + value.substring((i++) + 2); // form feed
 		    else if (value.charAt(i+1) == '\\')
 			    value = value.substring(0, i) + '\\' + value.substring((i++) + 2); // \
 		    else
 			    value = value.substring(0, i) + value.substring(i+1); // Quietly drop the character
        }

		// Lazily convert the string to a list of tokens.
		var arr = [], j, index;
		i = 0;
		while (i < value.length) {
			if (value.charAt(i) == '\'') {
				// Handle quotes
				if (i == value.length-1)
					value = value.substring(0, i); // Silently drop the trailing quote
				else if (value.charAt(i+1) == '\'')
					value = value.substring(0, i) + value.substring(++i); // Escaped quote
				else {
					// Quoted string
					j = i + 2;
					while ((j = value.indexOf('\'', j)) != -1) {
						if (j == value.length-1 || value.charAt(j+1) != '\'') {
							// Found start and end quotes. Remove them
							value = value.substring(0,i) + value.substring(i+1, j) + value.substring(j+1);
							i = j - 1;
							break;
						}
						else {
							// Found a double quote, reduce to a single quote.
							value = value.substring(0,j) + value.substring(++j);
						}
					}

					if (j == -1) {
						// There is no end quote. Drop the start quote
						value = value.substring(0,i) + value.substring(i+1);
					}
				}
			}
			else if (value.charAt(i) == '{') {
				// Beginning of an unquoted place holder.
				j = value.indexOf('}', i+1);
				if (j == -1)
					i++; // No end. Process the rest of the line. Java would throw an exception
				else {
					// Add 1 to the index so that it aligns with the function arguments.
					index = parseInt(value.substring(i+1, j));
					if (!isNaN(index) && index >= 0) {
						// Put the line thus far (if it isn't empty) into the array
						var s = value.substring(0, i);
						if (s != "")
							arr.push(s);
						// Put the parameter reference into the array
						arr.push(index);
						// Start the processing over again starting from the rest of the line.
						i = 0;
						value = value.substring(j+1);
					}
					else
						i = j + 1; // Invalid parameter. Leave as is.
				}
			}
			else
				i++;
		}

		// Put the remainder of the no-empty line into the array.
		if (value != "")
			arr.push(value);
		value = arr;

		// Make the array the value for the entry.
		$.i18n.map[key] = arr;
	}

	if (value.length == 0)
		return "";
	if (value.lengh == 1 && typeof(value[0]) == "string")
		return value[0];

	var s = "";
	for (i=0; i<value.length; i++) {
		if (typeof(value[i]) == "string")
			s += value[i];
		// Must be a number
		else if (phvList && value[i] < phvList.length)
			s += phvList[value[i]];
		else if (!phvList && value[i] + 1 < arguments.length)
			s += arguments[value[i] + 1];
		else
			s += "{"+ value[i] +"}";
	}

	return s;
};

/** Language reported by browser, normalized code */
$.i18n.browserLang = function() {
	return normaliseLanguageCode(navigator.language /* Mozilla */ || navigator.userLanguage /* IE */);
};


/** Load and parse .properties files */
function loadAndParseFile(filename, settings) {
	$.ajax({
        url:        filename,
        async:      false,
        cache:		settings.cache,
        contentType:'text/plain;charset='+ settings.encoding,
        dataType:   'text',
        success:    function(data, status) {
        				parseData(data, settings.mode);
					}
    });
}

/** Parse .properties files */
function parseData(data, mode) {
   var parsed = '';
   var parameters = data.split( /\n/ );
   var regPlaceHolder = /(\{\d+\})/g;
   var regRepPlaceHolder = /\{(\d+)\}/g;
   var unicodeRE = /(\\u.{4})/ig;
   for(var i=0; i<parameters.length; i++ ) {
       parameters[i] = parameters[i].replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim
       if(parameters[i].length > 0 && parameters[i].match("^#")!="#") { // skip comments
           var pair = parameters[i].split('=');
           if(pair.length > 0) {
               /** Process key & value */
               var name = unescape(pair[0]).replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim
               var value = pair.length == 1 ? "" : pair[1];
               // process multi-line values
               while(value.match(/\\$/)=="\\") {
               		value = value.substring(0, value.length - 1);
               		value += parameters[++i].replace( /\s\s*$/, '' ); // right trim
               }
               // Put values with embedded '='s back together
               for(var s=2;s<pair.length;s++){ value +='=' + pair[s]; }
               value = value.replace( /^\s\s*/, '' ).replace( /\s\s*$/, '' ); // trim

               /** Mode: bundle keys in a map */
               if(mode == 'map' || mode == 'both') {
                   // handle unicode chars possibly left out
                   var unicodeMatches = value.match(unicodeRE);
                   if(unicodeMatches) {
                     for(var u=0; u<unicodeMatches.length; u++) {
                        value = value.replace( unicodeMatches[u], unescapeUnicode(unicodeMatches[u]));
                     }
                   }
                   // add to map
                   $.i18n.map[name] = value;
               }

               /** Mode: bundle keys as vars/functions */
               if(mode == 'vars' || mode == 'both') {
                   value = value.replace( /"/g, '\\"' ); // escape quotation mark (")

                   // make sure namespaced key exists (eg, 'some.key')
                   checkKeyNamespace(name);

                   // value with variable substitutions
                   if(regPlaceHolder.test(value)) {
                       var parts = value.split(regPlaceHolder);
                       // process function args
                       var first = true;
                       var fnArgs = '';
                       var usedArgs = [];
                       for(var p=0; p<parts.length; p++) {
                           if(regPlaceHolder.test(parts[p]) && (usedArgs.length == 0 || usedArgs.indexOf(parts[p]) == -1)) {
                               if(!first) {fnArgs += ',';}
                               fnArgs += parts[p].replace(regRepPlaceHolder, 'v$1');
                               usedArgs.push(parts[p]);
                               first = false;
                           }
                       }
                       parsed += name + '=function(' + fnArgs + '){';
                       // process function body
                       var fnExpr = '"' + value.replace(regRepPlaceHolder, '"+v$1+"') + '"';
                       parsed += 'return ' + fnExpr + ';' + '};';

                   // simple value
                   }else{
                       parsed += name+'="'+value+'";';
                   }
               } // END: Mode: bundle keys as vars/functions
           } // END: if(pair.length > 0)
       } // END: skip comments
   }
   eval(parsed);
}

/** Make sure namespace exists (for keys with dots in name) */
// TODO key parts that start with numbers quietly fail. i.e. month.short.1=Jan
function checkKeyNamespace(key) {
	var regDot = /\./;
	if(regDot.test(key)) {
		var fullname = '';
		var names = key.split( /\./ );
		for(var i=0; i<names.length; i++) {
			if(i>0) {fullname += '.';}
			fullname += names[i];
			if(eval('typeof '+fullname+' == "undefined"')) {
				eval(fullname + '={};');
			}
		}
	}
}

/** Make sure filename is an array */
function getFiles(names) {
	return (names && names.constructor == Array) ? names : [names];
}

/** Ensure language code is in the format aa_AA. */
function normaliseLanguageCode(lang) {
    lang = lang.toLowerCase();
    if(lang.length > 3) {
        lang = lang.substring(0, 3) + lang.substring(3).toUpperCase();
    }
    return lang;
}

/** Unescape unicode chars ('\u00e3') */
function unescapeUnicode(str) {
  // unescape unicode codes
  var codes = [];
  var code = parseInt(str.substr(2), 16);
  if (code >= 0 && code < Math.pow(2, 16)) {
     codes.push(code);
  }
  // convert codes to text
  var unescaped = '';
  for (var i = 0; i < codes.length; ++i) {
    unescaped += String.fromCharCode(codes[i]);
  }
  return unescaped;
}

/* Cross-Browser Split 1.0.1
(c) Steven Levithan <stevenlevithan.com>; MIT License
An ECMA-compliant, uniform cross-browser split method */
var cbSplit;
// avoid running twice, which would break `cbSplit._nativeSplit`'s reference to the native `split`
if (!cbSplit) {
  cbSplit = function(str, separator, limit) {
      // if `separator` is not a regex, use the native `split`
      if (Object.prototype.toString.call(separator) !== "[object RegExp]") {
        if(typeof cbSplit._nativeSplit == "undefined")
          return str.split(separator, limit);
        else
          return cbSplit._nativeSplit.call(str, separator, limit);
      }

      var output = [],
          lastLastIndex = 0,
          flags = (separator.ignoreCase ? "i" : "") +
                  (separator.multiline  ? "m" : "") +
                  (separator.sticky     ? "y" : ""),
          separator = RegExp(separator.source, flags + "g"), // make `global` and avoid `lastIndex` issues by working with a copy
          separator2, match, lastIndex, lastLength;

      str = str + ""; // type conversion
      if (!cbSplit._compliantExecNpcg) {
          separator2 = RegExp("^" + separator.source + "$(?!\\s)", flags); // doesn't need /g or /y, but they don't hurt
      }

      /* behavior for `limit`: if it's...
      - `undefined`: no limit.
      - `NaN` or zero: return an empty array.
      - a positive number: use `Math.floor(limit)`.
      - a negative number: no limit.
      - other: type-convert, then use the above rules. */
      if (limit === undefined || +limit < 0) {
          limit = Infinity;
      } else {
          limit = Math.floor(+limit);
          if (!limit) {
              return [];
          }
      }

      while (match = separator.exec(str)) {
          lastIndex = match.index + match[0].length; // `separator.lastIndex` is not reliable cross-browser

          if (lastIndex > lastLastIndex) {
              output.push(str.slice(lastLastIndex, match.index));

              // fix browsers whose `exec` methods don't consistently return `undefined` for nonparticipating capturing groups
              if (!cbSplit._compliantExecNpcg && match.length > 1) {
                  match[0].replace(separator2, function () {
                      for (var i = 1; i < arguments.length - 2; i++) {
                          if (arguments[i] === undefined) {
                              match[i] = undefined;
                          }
                      }
                  });
              }

              if (match.length > 1 && match.index < str.length) {
                  Array.prototype.push.apply(output, match.slice(1));
              }

              lastLength = match[0].length;
              lastLastIndex = lastIndex;

              if (output.length >= limit) {
                  break;
              }
          }

          if (separator.lastIndex === match.index) {
              separator.lastIndex++; // avoid an infinite loop
          }
      }

      if (lastLastIndex === str.length) {
          if (lastLength || !separator.test("")) {
              output.push("");
          }
      } else {
          output.push(str.slice(lastLastIndex));
      }

      return output.length > limit ? output.slice(0, limit) : output;
  };

  cbSplit._compliantExecNpcg = /()??/.exec("")[1] === undefined; // NPCG: nonparticipating capturing group
  cbSplit._nativeSplit = String.prototype.split;

} // end `if (!cbSplit)`
String.prototype.split = function (separator, limit) {
    return cbSplit(this, separator, limit);
};

})(jQuery);
//jquery.i18n.properties.js end
/********************************core************************************************/
//MUUID.js start
/**
 * UUID函数，生成随机字符串
 */
(function() {
	var CHARS = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'.split('');
	MUUID = {
	        uuid : function(len, radix) {
    		var chars = CHARS, uuid = [], i;
    		radix = radix || chars.length;
    
    		if (len) {
    			for (i = 0; i < len; i++)
    				uuid[i] = chars[0 | Math.random() * radix];
    		} else {
    			var r;
    
    			uuid[8] = uuid[13] = uuid[18] = uuid[23] = '-';
    			uuid[14] = '4';
    
    			for (i = 0; i < 36; i++) {
    				if (!uuid[i]) {
    					r = 0 | Math.random() * 16;
    					uuid[i] = chars[(i == 19) ? (r & 0x3) | 0x8 : r];
    				}
    			}
    		}
    		return uuid.join('');
	        }
	    };
})();
//MUUID.js end
//MUtils.js start
/**
 * Created by yanghai on 2014/10/21 0021.
 */

var MUtils = (function () {

    function MUtils() {
    }

    var mTplCache = {};

    /**
     * 模版引擎
     * @param str
     * @param data
     * @returns {*|Function}
     */
    MUtils.tpl = function (str, data) {
        data = data || {};
        if (str[0] == '#')
            str = $(str).html();
        str = str.toString().trim();
        var fn = mTplCache[str]
            || new Function("o", "var p=[];with(o){p.push('"
            + str.replace(/[\r\t\n]/g, " ").replace(
                /'(?=[^%]*%})/g, "\t").split("'").join("\\'")
                .split("\t").join("'").replace(/{%=(.+?)%}/g,
                "',$1,'").split("{%").join("');")
                .split("%}").join("p.push('")
            + "');}return p.join('');");
        return fn.apply(data, [data]);
    };

    /**
     * 根据js名称获取所在目录
     * @param name
     * @returns {*}
     */
    MUtils.getFilePathByJSName = function (name) {
        var js = document.scripts || document.getElementsByTagName("script");
        var jsPath;
        for (var i = js.length; i > 0; i--) {
            if (js[i - 1].src.indexOf(name) > -1) {
                jsPath = js[i - 1].src.substring(0, js[i - 1].src
                    .lastIndexOf("/") + 1);
            }
        }
        return jsPath;
    };

    /**
     * 获取模版
     * @param refJSName
     * @param tplName
     * @returns {string}
     */
    MUtils.getTpl = function (refJSName, tplName) {
        var tplBasePath = MUtils.getFilePathByJSName(refJSName) + "tpl/";
        var tplPath = tplBasePath + tplName;
        return MUtils.readFileContent(tplPath);
    };

    /**
     * 根据基地址获取模版
     * @param basePath
     * @param tplPath
     * @returns {string}
     */
    MUtils.getTplByBasePath = function (basePath, tplPath) {
        var qualifiedPath = basePath + tplPath;
        return MUtils.readFileContent(qualifiedPath);
    };

    /**
     * 根据文件地址使用Ajax同步读取获得文件内容
     *
     * @param filePath
     * @param readType
     *            文件读取类型
     * @returns {string} 文件内容字符串
     */
    MUtils.readFileContent = function (filePath) {
        var  readType = arguments[1];
        var fileContent;
        if (!readType) {
            readType = "text";
            fileContent = "";
        }
        $.ajax({
            type    : "GET",
            url     : filePath,
            async   : false, // 设为false就是同步请求
            cache   : false,
            dataType: readType,
            success : function (content) {
                fileContent = content;
            }
        });
        return fileContent;
    };

    /**
     * 获取附件显示大小
     *
     * @param size
     *            附件的文件大小值
     */
    MUtils.getAttSize = function (size) {
        if (size == null) {
            return "";
        }
        if (typeof size == "string") {
            size = parseInt(size);
        }
        var fileSize;
        if (size == 0) {
            fileSize = "";
        } else {
            var k = 0;
            fileSize = size;
            while (fileSize >= 1024) {
                fileSize = fileSize / (1024);
                k++;
            }
            fileSize = fileSize.toString();
            var inte = fileSize.indexOf(".") > 0 ? fileSize.substring(0,
                fileSize.indexOf(".")) : fileSize;
            var flot = fileSize.indexOf(".") > 0 ? fileSize.substring(fileSize
                .indexOf(".")) : "";
            if (flot.length > 3) {
                flot = flot.substring(0, 2);
            }
            fileSize = inte + flot;
            var suff = ["B", "KB", "MB", "GB", "TB"];
            fileSize = fileSize + suff[k];
        }
        return fileSize;
    };

    /**
     * 根据icon类型获取icon 样式名称
     * @param iconType
     * @returns {string}
     */
    MUtils.getIcon = function (iconType) {
        var icon = "ic_unkown";
        iconType = iconType.toLowerCase();
        if (iconType == "form") {
            icon = "ic_form";
        } else if (iconType == "news") {
            icon = "ic_news";
        } else if (iconType == "discuss") {
            icon = "ic_discuss";
        } else if (iconType == "plan") {
            icon = "ic_plan";
        } else if (iconType == "ann") {
            icon = "ic_ann";
        } else if (iconType == "et") {
            icon = "ic_et";
        } else if (iconType == "picture" || iconType == "img" || iconType == "image" || iconType == "gif" || iconType == "png" || iconType == "jpg" || iconType == "jpeg" || iconType == "bmp") {
            icon = "ic_picture";
        } else if (iconType == "survey") {
            icon = "ic_survey";
        } else if (iconType == "zip") {
            icon = "ic_zip";
        } else if (iconType == "txt") {
            icon = "ic_txt";
        } else if (iconType == "tif") {
            icon = "ic_tif";
        } else if (iconType == "forder") {
            icon = "ic_forder";
        } else if (iconType == "metting") {
            icon = "ic_metting";
        } else if (iconType == "pdf") {
            icon = "ic_pdf";
        } else if (iconType == "video") {
            icon = "ic_video";
        } else if (iconType == "off_doc") {
            icon = "ic_off_doc";
        } else if (iconType == "mp4") {
            icon = "ic_mp4";
        } else if (iconType == "htm") {
            icon = "ic_htm";
        } else if (iconType == "mp3") {
            icon = "ic_mp3";
        } else if(iconType == "amr"){
            icon = "ic_arm";
        } else if (iconType == "ppt" || iconType == "pptx") {
            icon = "ic_ppt";
        } else if (iconType == "rar") {
            icon = "ic_rar";
        } else if (iconType == "html") {
            icon = "ic_html";
        } else if (iconType == "col") {
            icon = "ic_col";
        } else if (iconType == "mov") {
            icon = "ic_mov";
        } else if (iconType == "vsd") {
            icon = "ic_vsd";
        } else if (iconType == "wps") {
            icon = "ic_wps";
        } else if (iconType == "xls" || iconType == "xlsx") {
            icon = "ic_xls";
        } else if (iconType == "doc" || iconType == "docx") {
            icon = "ic_doc";
        } else if (iconType == "mail") {
            icon = "ic_mail";
        }
        return icon;
    };

    /**
     * 根据数据传的类获取图标 icon样式名称
     * @param iconType
     */
    MUtils.getQuickMenuIcon = function (iconType) {
        var icon = "ic_unkown";
        if (typeof iconType == "string") {//如果是字符串类型就转换成int类型
            iconType = parseInt(iconType);
        }
        switch (iconType) {
            case 100:
                icon = "iconNewcollaboration";
                break;
            case 101:
                icon = "iconNewitems";
                break;
            case 102:
                icon = "iconFastSign";
                break;
            case 103:
                icon = "iconSweep";
                break;
            case 104:
                icon = "iconTodoitem";
                break;
            case 105:
                icon = "iconUnpublishedList";
                break;
            case 106:
                icon = "iconUnheldMeeting";
                break;
            case 107:
                icon = "iconDocumentTodo";
                break;
            case 108:
                icon = "iconDocumentsDispatch";
                break;
            case 109:
                icon = "iconDocumentsSign";
                break;
            case 110:
                icon = "iconDocumentsIncoming";
                break;
            case 111:
                icon = "iconMailList";
                break;
            case 112:
                icon = "iconHaveTodoitem";
                break;
            case 113:
                icon = "iconPublishedItem";
                break;
            case 114:
                icon = "iconHeldMeeting";
                break;
            case 115:
                icon = "iconContact";
                break;
            default :
                break;
        }

        return icon;
    };

    /**
     * 判断设备类型
     */
    MUtils.os = function (u) {
        return { // 移动终端浏览器版本信息
            trident: u.indexOf('Trident') > -1, // IE内核
            presto : u.indexOf('Presto') > -1, // opera内核
            webKit : u.indexOf('AppleWebKit') > -1, // 苹果、谷歌内核
            gecko  : u.indexOf('Gecko') > -1 && u.indexOf('KHTML') == -1, // 火狐内核
            mobile : !!u.match(/AppleWebKit.*Mobile.*/), // 是否为移动终端
            ios    : !!u.match(/\(i[^;]+;( U;)? CPU.+Mac OS X/), // ios终端
            android: u.indexOf('Android') > -1 || u.indexOf('Linux') > -1, // android终端或uc浏览器
            iPhone : u.indexOf('iPhone') > -1, // 是否为iPhone或者QQHD浏览器
            iPad   : u.indexOf('iPad') > -1, // 是否iPad
            webApp : u.indexOf('Safari') == -1
            // 是否web应该程序，没有头部与底部
        };
    }(navigator.userAgent);

    /**
     * 判断元素是否出现在指定容器中(判断可见否)
     * 调用方式
     * MUtils.isVisible("#columns","#obj",true);
     * @param container //容器选择器
     * @param objSelector //元素选择器
     * @param isVertical //是否是垂直检测
     * @returns {boolean}
     */
    MUtils.isVisible = function (container, objSelector, isVertical) {
        var $obj = $(objSelector);
        var offset = null;
        if ($obj) {
            offset = $obj.offset();
        }
        if (!isVertical) isVertical = true;
        var OFFSET = {
            view: [isVertical ? 'top' : 'left', isVertical ? 'height' : 'width'],
            ele : [isVertical ? 'top' : 'left', isVertical ? 'height' : 'width']
        };
        var viewOffset = $(container).offset(),
            viewTop = viewOffset[OFFSET.view[0]],
            viewHeight = viewOffset[OFFSET.view[1]];
        return viewTop >= offset[OFFSET.ele[0]] - 0 - viewHeight && viewTop <= offset[OFFSET.ele[0]] + offset[OFFSET.ele[1]];
    };

    /**
     * div元素移动到某一个位置
     * @param elem
     * @param x
     * @param y
     */
    MUtils.sliderTo = function (elem, x, y) {
        var vendor = (/webkit/i).test(navigator.appVersion) ? 'webkit'
                : (/firefox/i).test(navigator.userAgent) ? 'Moz'
                : 'opera' in window ? 'O' : '',
        // Browser capabilities
            has3d = 'WebKitCSSMatrix' in window && 'm11' in new WebKitCSSMatrix(),
        // Helpers
            trnOpen = 'translate' + (has3d ? '3d(' : '('), trnClose = has3d ? ',0)' : ')';
        elem.style[vendor + 'TransitionProperty'] = '-' + vendor.toLowerCase() + '-transform';
        elem.style[vendor + 'TransitionDuration'] = 500 + 'ms';
        elem.style[vendor + 'Transform'] = trnOpen + x + 'px,' + y + 'px' + trnClose;
    };

    /**
     * 截取中英文字符串
     * @param str 字符串
     * @param len 截取长途
     * @param hasDot 是否增加 ...
     * @returns {string}
     */
    MUtils.subStr = function (str, len, hasDot) {
        var newLength = 0;
        var newStr = "";
        var chineseRegex = /[^\x00-\xff]/g;
        var singleChar = "";
        var strLength = str.replace(chineseRegex, "**").length;
        for (var i = 0; i < strLength; i++) {
            singleChar = str.charAt(i).toString();
            if (singleChar.match(chineseRegex) != null) {//中文加2
                newLength += 2;
            } else {//英文加1
                newLength++;
            }
            if (newLength > len) {//如果新长度超过截取长度则跳出循环
                break;
            }
            newStr += singleChar;//将当前字符加到新的字符串中
        }
        if (hasDot && strLength > len) {//添加 "..."
            newStr += "...";
        }
        return newStr;
    };


    /**
     * 解析字符串中包含了部分国际化key的string
     * @param containI18nStr:有国际化资源字符串特征的字符串
     * @returns {string}
     */
    MUtils.parseI18nKey = function(containI18nStr) {
        var i18nFeature = /\|i18n\(\S*\)\|/ig;
        var i18nKeyFeature = /i18n\(\S*\)/ig;
        var separator = "|";
        var displayStr = "";
        if(i18nFeature.test(containI18nStr)) {
            var splitedStrArr = containI18nStr.split(separator);
            var len = splitedStrArr.length;
            if(len > 0) {
                var result = "";
                for(var i = 0 ; i < len ; i ++) {
                    if(i18nKeyFeature.test(splitedStrArr[i])) {
                        var i18nFeatureStr = containI18nStr.match(i18nKeyFeature)[0];
                        var key = i18nFeatureStr.substring(i18nFeatureStr.indexOf("(")+1,i18nFeatureStr.indexOf(")"));
                        var temp = $.i18n.prop(key);
                        result += temp;
                    }else {
                        result += splitedStrArr[i];
                    }
                }
                displayStr = result;
            }

        }else {
            displayStr = $.i18n.prop(containI18nStr);
        }
        return displayStr;
    };
    
    /**
     * 转译尖括号
     */
    MUtils.parseAngleBrackets = function(Str) {
        var _ltOr_gtFeature = /<\S[^>]+>/g;
        var result = "";
        if(_ltOr_gtFeature.test(Str)) {
            result = Str.replace(new RegExp("<","g"),"&lt;").replace(new RegExp(">","g"),"&gt;");
        }else {
            result = Str;
        }
        return result;

    };
    /**
     * 获取浏览器语言环境
     * @returns {*}
     */
    MUtils.getLanguage = function() {
        var lang;
        var enRegex = /en/g;
        var chiRegex = /zh/g;
        if(navigator && navigator.userAgent && (lang = navigator.userAgent.match(/android.*\W(\w\w)-(\w\w)\W/i))){
            lang = lang[1];
        }
        if(!lang && navigator) {
            if (navigator.language) {
                lang = navigator.language;
            } else if (navigator.browserLanguage) {
                lang = navigator.browserLanguage;
            } else if (navigator.systemLanguage) {
                lang = navigator.systemLanguage;
            } else if (navigator.userLanguage) {
                lang = navigator.userLanguage;
            }
        }

        if(enRegex.test(lang)) {
            lang = "en";
        }else if(chiRegex.test(lang)) {
            lang = (lang.toLocaleLowerCase().indexOf("cn") > -1) ? "zh-CN" : "zh-TW";
        }
        return lang;
    };
    /**
     * 判断对象是否不为空
     * @param obj
     * @returns {boolean}
     */
    MUtils.judgeObjNotNull = function(obj) {
        var hasProp = false;
        obj = eval("" + obj);
        if (typeof obj === "object"){
            for (var prop in obj){
                hasProp = true;
                break;
            }
        }
        return hasProp;
    };
    /**
     * 判断是否是数字
     * @param value
     * @returns {boolean}
     */
    MUtils.isNumber = function(value) {
        //if (typeof value == "string") {
        //    value = value;
        //}
        return /^[-+]?\d*([\.]\d+)?$/.test(value);
    };

    /**
     * 复制字符串自身
     * @param target
     * @param n
     * @returns {string}
     */
    MUtils.repeatStr = function(target,n) {
        var s = target;
        var result = "";
        while(n > 0) {
            if(n % 2 == 1)
                result += s;
            if(n == 1)
                break;
            s += s;
            n = n >> 1;
        }
        return result;
    };

    MUtils.convertImgUrlV52CMP = function(V5Url,jsessionId){
        var args = V5Url.split("?");
        if (args[0] == V5Url){/* 参数为空 */
            return V5Url;
            /* 无需做任何处理 */
        }
        var str = args[1];
        args = str.split("&");

        var _args = {};
        for (var i = 0; i < args.length; i++){
            str = args[i];
            var arg = str.split("=");
            if(arg.length <= 1){
                _args[arg[0]] = "";
            }else{
                _args[arg[0]] = arg[1];
            }
        }
        var CMPUrl = "/seeyon/servlet/SeeyonMobileBrokerServlet?serviceProcess=A6A8_File&method=download";

        if(jsessionId){
            CMPUrl =  "/seeyon/servlet/SeeyonMobileBrokerServlet;jsessionid="+jsessionId+"?serviceProcess=A6A8_File&method=download";
        }

        CMPUrl += "&fileId=" + _args["fileId"];
        CMPUrl += "&createDate=" + _args["createDate"];
        CMPUrl += "&type=" + 2;

        return CMPUrl;
    };

    MUtils.mRequestAjaxParams = function(managerName, method, arguments){
        var param = {}
        param.managerName = managerName;
        param.managerMethod = method;
        if(arguments && arguments != null && arguments != "" && typeof arguments != 'undefined') {
            param.arguments = $.toJSON(arguments);
        }else {
            param.arguments = "";
        }
        return param;
    };
    MUtils.mRequestForAjax = function(url, mRequestAajax, callback) {
        $.post(url, mRequestAajax, function (result) {
            callback(result);
        }, "json");
    };

    var localStore;
    var sessionStore;

    MUtils.getStore = function(isLocal){
        if(isLocal){
            if(!localStore) localStore = new LocalStore();
            return localStore;
        }else{
            if(!sessionStore) sessionStore = new SessionStore();
            return sessionStore;
        }
    };

    return MUtils;

})();

var cmp = (function(){
    function Store(storeType){
        this.storage = window[storeType];
    }
    Store.prototype.set = function(key,value){
        this.storage.setItem(key,value);
    };
    Store.prototype.get = function(key){
        return this.storage.getItem(key);
    };
    Store.prototype.remove = function(key){
        this.storage.remove(key);
    };
    Store.prototype.clear = function(){
        this.storage.clear();
    };
    function cmp (){}
    var localStore,sessionStore;
    cmp.STORETYPE_LOCAL = "localStorage";
    cmp.STORETYPE_SESSION = "sessionStorage";
    cmp.getStore = function(){
        var len = arguments.length;
        var isLocal = len ? arguments[0]:cmp.STORETYPE_LOCAL ;
        if(isLocal == cmp.STORETYPE_LOCAL){
            if(!localStore) localStore = new Store(cmp.STORETYPE_LOCAL);
            return localStore;
        }else {
            if(!sessionStore) sessionStore = new Store(cmp.STORETYPE_SESSION);
            return sessionStore;
        }
    };
    return cmp;
})();


var MEvent = (function () {
    function MEvent() {
    }

    //如果不是移动设备都为点击事件，如果为移动设备都为触摸事件
    MEvent.C_sEvent_CLICK = "click";
    if (MUtils.os.android || MUtils.os.ios) {
        MEvent.C_sEvent_CLICK = "tap";
    }

    return MEvent;
})();
//MUtils.js end
//MDate.js start
(function() {
	/**
	 * 日期格式化
	 * @param format
	 * @returns {*}
	 */
	Date.prototype.format = function(format) {
		var o = {
			"M+": this.getMonth() + 1, //month
			"d+": this.getDate(), //day
			"h+": this.getHours(), //hour
			"m+": this.getMinutes(), //minute
			"s+": this.getSeconds(), //second
			"q+": Math.floor((this.getMonth() + 3) / 3), //quarter
			"S": this.getMilliseconds() //millisecond
		};
		if (/(y+)/.test(format)) format = format.replace(RegExp.$1, (this.getFullYear() + "").substr(4 - RegExp.$1.length));
		for (var k in o)
			if (new RegExp("(" + k + ")").test(format))
				format = format.replace(RegExp.$1,
					RegExp.$1.length == 1 ? o[k] :
					("00" + o[k]).substr(("" + o[k]).length));
		return format;
	};

    Array.prototype.peek = function(){
        var length = this.length;
        if(length>0){
            return this[length - 1];
        }else{
            return undefined;
        }
    }
})();
//MDate.js end
//MMap.js s
/**
 * 模拟一个Map对象
 */
(function() {
    MMap = function() {
        this.container = {};
    };

    MMap.prototype = {
        put : function(key, value) {
            try {
                if (key != null && key != "") {
                    this.container[key] = value;
                }
            } catch (e) {
                return e;
            }
        },

        get : function(key) {
            try {
                return this.container[key];
            } catch (e) {
                return e;
            }
        },

        containsKey : function(key) {
            try {
                for ( var p in this.container) {
                    if (p == key) {
                        return true;
                    }
                }
                return false;
            } catch (e) {
                return e;
            }
        },

        containsValue : function(value) {
            try {
                for ( var p in this.container) {
                    if (this.container[p] === value) {
                        return true;
                    }
                }
                return false;
            } catch (e) {
                return e;
            }
        },

        remove : function(key) {
            var result = null;
            try {
                result = this.container[key];
                delete this.container[key];
            } catch (e) {
                return result;
            }
            return result;
        },

        clear : function() {
            try {
                delete this.container;
                this.container = {};
            } catch (e) {
                return e;
            }
        },

        isEmpty : function() {
            if (this.keyArray().length == 0) {
                return true;
            } else {
                return false;
            }
        },

        size : function() {
            return this.keyArray().length;
        },

        keyArray : function() {
            var keys = new Array();
            for ( var p in this.container) {
                keys.push(p);
            }
            return keys;
        },

        valueArray : function() {
            var values = new Array();
            var keys = this.keyArray();
            for (var i = 0; i < keys.length; i++) {
                values.push(this.container[keys[i]]);
            }
            return values;
        }
    };
})();
//MMap.js e
//MList.js s
/**
 * Created by yanghai on 14-10-14.
 * 用于CMP平台列表构建
 */

var MList;
MList = (function ($) {

    var $list_data = '<div class="list_data"></div>';
    var $pull_down = '<div class="pullDown">' +
        '<span class="pullDownIcon"></span>' +
        '<div class="pullDownText">' +
        '<p id="cmp_textForPullDown">{textForPullDown}</p>' +
        '<p id="cmp_textForPullDownListNumSum">{textForPullDownListNumSum}</p>' +
        '<p id="cmp_textForPullDownListTime">{textForPullDownListTime}</p>' +
        '</div>' +
        '</div>';
    var $pull_up = '<div class="clickDown loading">' +
        '<p class="margin_t_15" id="cmp_textForClickDownLoadMore">{textForClickDownLoadMore}</p>' +
        '<p class="margin_t_5" id="cmp_textForClickDownListNum">{textForClickDownListNum}' +
        '<span class="pullDownIcon"></span>' +
        '</div>';
    /**
     * 构造函数
     * @param id 滚动面板的ID
     * @param options 可选参数
     * @constructor
     */
    var MList = function (id, options) {
        var _this = this;
        _this.MListJSBasePath = MUtils.getFilePathByJSName('MList.js') + "tpl/";
        _this.defaultItemTplPath = _this.MListJSBasePath + 'm_list_item_tpl.html';
        _this.defaultNoneDataTplPath = _this.MListJSBasePath + 'm_list_default_no_data_tpl.html';
        _this.defaultRefreshShowData = {
            listNum: 0,
            listTime: new Date().format("yyyy-MM-dd hh:mm:ss"),
            moreListNum: 0
        };
        _this.options = {
            MListType: MList.MListType.dataShow,//列表组件的类型
            pullDownFunc: null,//列表组件下拉刷新的回调函数
            loadMoreFunc: null,//列表组件点击加载更多的回调函数
            hScroll: false,//列表组件是否支持横向滚动
            vScroll: true,//列表组件是否支持纵向滚动
            itemTplPath: _this.defaultItemTplPath,//列表组件列表项的模版文件地址
            noDataTplPath: _this.defaultNoneDataTplPath,//列表组件没有数据的模版文件地址
            refreshDomText: {//配置上拉下拉控件的文字显示（使用配置便于国际化）
                textForPullDown: '下拉刷新',//下拉刷新
                textForPullDownRelease: '松手开始更新',//松手开始更新
                textForPullDownListNumSum: '共{listNum}条',//共有多少数据
                textForPullDownListTime: '最近更新：{listTime}',//最近更新时间
                textForClickDownLoadMore: '加载更多',//加载更多
                textForClickDownListNum: '还有{moreListNum}条',//还剩下多少条
                textForLoading: '加载中'//加载中
            },
            imgLazyLoad: {//图片懒加载配置
                enabled: false,//是否启用懒加载
                cmpClassName: 'cmp-imglazyload',//懒加载标识
                urlAttrName: 'data-url'//真是图片地址属性
            },
            pageSize:20
        };
        //滚动面板的id
        _this.id = id;
        //上拉下拉刷新的滚动界限值
        _this.refreshScrollNum = 5;
        //iScroll实列化后的对象
        _this.myScroll = null;
        //滚动面板 对象
        _this.wrapper = null;

//        _this.pageNumber = 1;

        $.extend(true, _this.options, options);
        
        _this.pageSize = _this.options.pageSize;

        _this._init();
    };

    /**
     * 列表组件的类型
     * @type {{dataRefresh: number, dataShow: number}}
     */
    MList.MListType = {
        dataRefresh: 0,//含上拉下拉刷新类型
        dataShow: 1//不含上拉下拉刷新类型
    };

    /**
     * 为MList类添加函数
     * @type {{init: init, setData: setData}}
     */
    MList.prototype = {
        currentCount:0,
        pageSize:20,
        /**
         * 组件初始化
         */
        _init: function () {
            var _this = this;
            var $wrapper;

            if (_this.id[0] != "#") {
                _this.wrapper = $wrapper = $("#" + _this.id);
            } else {
                _this.wrapper = $wrapper = $(_this.id);
                _this.id = _this.id.substring(1, _this.id.length);
            }
            $wrapper.append($('<div class="scroller" id="'+ _this.id+'_scroller"></div>'));

            var $scroll = $($wrapper.find('#'+_this.id+'_scroller')[0]);

            if (_this.myScroll != null) {
                _this.myScroll.destroy();
            }
            //判断初始化类型
            switch (_this.options.MListType) {
                case MList.MListType.dataRefresh:
                    //为滚动区域添加上拉、数据显示、下拉dom
                    $scroll.append($pull_down).append($list_data).append($pull_up);

                    _this._setRefreshDomShow();

                    var pullDownEl = $wrapper.find('.pullDown')[0];
                    var pullDownE2 = $wrapper.find('.pullDown');
                    var pullDownOffset = pullDownEl.offsetHeight;
                    var pullUpE2 = $wrapper.find('.clickDown');
                    _this.myScroll = new iScroll(_this.id, {
                        scrollbarClass: 'myScrollbar',
                        useTransition: false,
                        fixedScrollbar: false,
                        hScroll: _this.options.hScroll,
                        vScroll: _this.options.vScroll,
                        topOffset: pullDownOffset,
                        /**
                         *  调整刷新后的界面结构
                         */
                        onRefresh: function () {
                            if (pullDownE2.hasClass('loading')) {
                                pullDownE2.removeClass('loading');
                                pullDownE2.find("p").show();
                                $(pullDownE2.find("p")).first()
                                    .removeClass("change_text_height")
                                    .text(_this.options.refreshDomText.textForPullDown);
                            }
                            else if (pullUpE2.hasClass('loading')) {
                                pullUpE2.find("p").show();
                                pullUpE2.find("span").hide();
                                $(pullUpE2.find("p")).first()
                                    .removeClass("margin_t_25")
                                    .addClass("margin_t_15")
                                    .text(_this.options.refreshDomText.textForClickDownLoadMore);
                            }
                        },
                        /**
                         *  判断当前滚动是到顶端还是底端
                         */
                        onScrollMove: function () {
                            if (this.y > _this.refreshScrollNum && !pullDownE2.hasClass('flip')) {
                                pullDownE2.addClass('flip');
                                $(pullDownE2.find("p")).first().text(_this.options.refreshDomText.textForPullDownRelease);
                                this.minScrollY = 0;
                            } else if (this.y < _this.refreshScrollNum && pullDownE2.hasClass('flip')) {
                                pullDownE2.removeClass('flip');
                                $(pullDownE2.find("p")).first().text(_this.options.refreshDomText.textForPullDown);
                                this.minScrollY = -pullDownOffset;
                            }
                        },
                        /**
                         *  参数方法触发加载新数据，再通过refresh方法重新渲染界面
                         */
                        onScrollEnd: function () {
                            if ($wrapper.height() <= ($wrapper.find(".list_data").height() + pullDownOffset)) {
                                pullUpE2.css("opacity", "1");
                                pullUpE2.unbind("tap").bind("tap", function () {
                                    pullUpE2.find("p").hide();
                                    pullUpE2.find("span").show();
                                    $(pullUpE2.find("p")).first().removeClass("margin_t_15").addClass("margin_t_25").text(_this.options.refreshDomText.textForLoading).show();
                                    _this.options.loadMoreFunc(this);
                                });
                            }
                            if (pullDownE2.hasClass('flip')) {
                                pullDownE2.removeClass('flip').addClass('loading');
                                pullDownE2.find("p").hide();
                                $(pullDownE2.find("p")).first().addClass("change_text_height").text(_this.options.refreshDomText.textForLoading).show();
                                _this.options.pullDownFunc(this);
                            }
                            if (_this.options.imgLazyLoad.enabled) {
                                $.fn.imgLazyLoad.detect();
                            }
                        }
                    });
                    break;
                case  MList.MListType.dataShow:
                    $scroll.append($list_data);
                    _this.myScroll = new iScroll(_this.id, {
                        scrollbarClass: 'myScrollbar',
                        hScroll: _this.options.hScroll,
                        vScroll: _this.options.vScroll,
                        hideScrollbar: true,
                        fadeScrollbars: true,
                        hScrollbar:false,
                        bounce: true,
                        onScrollEnd: function () {
                            if (_this.options.imgLazyLoad.enabled) {
                                $.fn.imgLazyLoad.detect();
                            }
                        }
                    });
                    break;
                default :
                    break;
            }

            _this._initImgLazyLoad();
        },
        /**
         * 图片懒加载初始化
         */
        _initImgLazyLoad: function () {
            var _this = this;
            if (_this.options.imgLazyLoad.enabled) {
                $('.' + _this.options.imgLazyLoad.cmpClassName).on('startload', function () {
                    $(this).removeClass('preload');
                }).imgLazyLoad({
                    urlName: _this.options.imgLazyLoad.urlAttrName
                });
            }
        },
        /**
         * 设置上拉下拉刷新所显示的值
         */
        _setRefreshDomShow: function () {
            var _this = this;
            for (var j in _this.options.refreshDomText) {
                var $cmpJ = _this.wrapper.find("#cmp_" + j);
                $cmpJ.html(_this.options.refreshDomText[j]);
                for (var k in _this.defaultRefreshShowData) {
                    if (_this.options.refreshDomText[j].indexOf('{' + k + '}') < 0) {
                        continue;
                    }
                    $cmpJ.html(_this.options.refreshDomText[j].replace("{" + k + "}"
                        , _this.defaultRefreshShowData[k]));
                }
            }
        },
        /**
         * 根据数据设置数据
         * @param dataObj 数据对象
         * @param callback 页面跳转回调函数
         */
        setDataForDefaultTplOrInitTpl: function (dataObj, callback) {
            var _this = this;
            _this.setData(_this.options.itemTplPath, dataObj, callback);
        },
        /**
         * 根据模版地址和数据对象设置 没有数据的情况所显示的内容并刷新列表
         * @param noneDataTplPath 没有数据的模版
         * @param dataObj 没有数据的 模版数据对象
         * @param callback 页面跳转回调函数
         */
        setNoDataShow: function (noneDataTplPath, dataObj, callback) {
            var _this = this;
            dataObj = !dataObj ? {} : dataObj;
            if (!noneDataTplPath) {
                noneDataTplPath = _this.options.noDataTplPath;
            }
            _this.setData(noneDataTplPath, dataObj, callback);
        },
        /**
         * 根据模版地址和数据对象设置数据并刷新列表
         * @param tplPath 列表区域模版文件地址
         * @param dataObj 模版文件对应的数据对象
         * @param callback 页面回调函数
         */
        setData: function (tplPath, dataObj, callback) {
            var _this = this;
            if (_this.myScroll == null) {
                throw "myScroll is not init!";
            }
            if (!tplPath) {
                throw "tplPath can not null or undefined!";
            }

            dataObj = !dataObj ? {} : dataObj;

            if(_this.options.MListType == MList.MListType.dataRefresh){
                //设置共有多少条数
                if (dataObj.list_num) {
                    _this.defaultRefreshShowData.listNum = dataObj.list_num;
                }
                //设置刷新时间
                if (dataObj.update_time) {
                    if(dataObj.update_time instanceof Date){
                        _this.defaultRefreshShowData.listTime = dataObj.update_time.format("yyyy-MM-dd hh:mm:ss");
                    }else{
                        _this.defaultRefreshShowData.listTime = dataObj.update_time;
                    }
                }
                //设置还剩下多少条
                if (dataObj.more_num) {
                    _this.defaultRefreshShowData.moreListNum = dataObj.more_num;
                }

                _this._setRefreshDomShow();
            }

            var tplHtmlStr = MUtils.readFileContent(tplPath);

            var liHtml = MUtils.tpl(tplHtmlStr, dataObj);

            var $listDataDom = $(_this.wrapper.find(".list_data"));

            $listDataDom.html($listDataDom.html() + liHtml);

            $listDataDom.trigger('create');

            if(_this.options.hScroll){
                var $scroll = $(_this.wrapper.find(".scroller")[0]);
                $scroll.width($listDataDom.children().width() * $listDataDom.children().length);
            }


            if(callback){
                $listDataDom.children().each(function(){
                    callback($(this));
                });
            }

            _this._initImgLazyLoad();

            _this.myScroll.refresh();
        },
        /**
         * 清除列表中现有的数据
         */
        clearData:function(){
            var _this = this;
            $(_this.wrapper.find(".list_data")).empty();
        },
        /**
         * 列表滚动到指定位置
         * @param x
         * @param y
         */
        scrollTo:function(x,y){
            this.myScroll.scrollTo(x,y);
        },
        /**
         * 列表移除指定item
         * @param item
         */
        removeItem:function(item){
        	item.remove();
        	this.myScroll.refresh();
        },
        /**
         * 获取列表的所有item
         * @returns
         */
        getItemList:function(){
        	return this.wrapper.find(".list_data").children();
        },
        /**
         * 移除上拉刷新控件
         */
        removeClickDown:function(){
        	this.wrapper.find(".clickDown").hide();
//        	this.wrapper.find(".clickDown").remove();
        },
        /**
         * 显示上拉刷新控件
         */
        displayClickDown : function() {
            this.wrapper.find(".clickDown").show();
        }
    };
    return MList;
})(jQuery);
//MList.js e
//MUiLibrary.js s
/**
 * Created by Administrator on 2015-5-18.
 */
/*================复写表单组在移动端没有加载进的函数和修改符合移动端的=========*/
(function($){
    if(typeof $.alert == 'undefined') {
        $.alert = function(msg,okCallback,cancelCallback) {
            var newMsg = "";
            if(typeof msg == "object") {
                newMsg = msg.msg;
            }else {
                newMsg = msg;
            }
            if($(".cmp_prompt_withNoShieldLayer").length > 0) return;
            var okFun = (okCallback == undefined) ? null : okCallback;
            var cancelFun = (cancelCallback == undefined) ? null : cancelCallback;
            var promptBox = new CMPPromptBox(newMsg,okFun,cancelFun,2);
            promptBox.close();
            promptBox.ok();

        }
    }
	if(typeof $.prompt == 'undefined') {
		$.prompt = function(msg){
			var newMsg = "";
            if(typeof msg == "object") {
                newMsg = msg.msg;
            }else {
                newMsg = msg;
            }
            if($(".cmp_prompt_withNoShieldLayer").length > 0) return;
            var promptBox = new CMPPromptBox(newMsg,null,null,1);
            promptBox.ok();
		}
	}

})(jQuery);
/*==================符合移动端的一个进度条=======================*/
CMPPromptBoxConstant = {
	C_iSPromptType_withNoCancelBtn :1,
	C_iSPromptType_withCancelBtn : 2
}
function CMPProgressBar(iconClass,content) {
    var _this = this;
    _this.progress = $('<div class="cmp_loading_withNoShieldLayer">' +
        '   <div class="tipsBox">' +
        '       <div class="tipsContent">' +
        '           <span class="'+iconClass+'"></span>' +
        '           <span class="text">'+content+'</span>' +
        '       </div>' +
        '   </div>' +
        '</div>');
    _this.progress.appendTo(document.body);
}
CMPProgressBar.prototype = {
    close : function() {
        var _this = this;
        _this.progress.remove();
        _this = null;
    }
}
/*============符合移动端的一个提示框=============*/
function CMPPromptBox(msg,okCallback,cancelCallback,type) {
    var _this = this;
    _this.okCallback = okCallback;
    _this.cancelCallback = (type == CMPPromptBoxConstant.C_iSPromptType_withCancelBtn)? cancelCallback : null;
	var promptBoxHtml = "";
	promptBoxHtml += '<div class="cmp_prompt_withNoShieldLayer">'+
		'<div class="cmpTipsBox appendTextWidgetAnimationOpen cmp_divTransform_Scale03">'+
        '<div class="titleArea">' +
        '<div class="title">'+msg+'</div>'+
        '</div>'+
        '<div class="btnArea">';
	if(type == CMPPromptBoxConstant.C_iSPromptType_withCancelBtn) {
		promptBoxHtml +='<div class="cancel">取消</div>';
	}        
        promptBoxHtml += '<div class="ok">确定</div>'+
        '</div>'+
        '</div>'+
        '</div>';
    _this.promptBox = $(promptBoxHtml);
    _this.tipsBox = $(".cmpTipsBox",_this.promptBox);
    _this.closeBtn = (type == CMPPromptBoxConstant.C_iSPromptType_withCancelBtn)? $(".cancel",_this.promptBox) : null;
    _this.okBtn = $(".ok",_this.promptBox);
    var height = $(document).height();
    var top = $(document).scrollTop();
    _this.promptBox.css("height",height).css("top",top);
    _this.promptBox.appendTo(document.body);
    setTimeout(function() {
        _this.tipsBox.removeClass("cmp_divTransform_Scale03").addClass("cmp_divTransform_Scale1");
    },50);
}
CMPPromptBox.prototype = {
    close : function() {
        var _this = this;
        var callback = _this.cancelCallback;
        var promptBox = _this.promptBox;
        _this.closeBtn.unbind("click").bind("click",function() {
            if(callback) {
                callback();
            }
            _this.tipsBox.removeClass("cmp_divTransform_Scale1").addClass("cmp_divTransform_Scale03");
            setTimeout(function() {
                promptBox.remove();
            },100);

            _this = null;
        });

    },
    ok : function() {
        var _this = this;
        var callback = _this.okCallback;
        var promptBox = _this.promptBox;
        _this.okBtn.unbind("click").bind("click",function() {
            if(callback) {
                callback();
            }
            _this.tipsBox.removeClass("cmp_divTransform_Scale1").addClass("cmp_divTransform_Scale03");
            setTimeout(function() {
                promptBox.remove();
            },100);
            _this = null;
        });

    }
}
//MUiLibrary.js e
//CMPUtils.js s
/**
 * Created by Administrator on 2015/3/30 0030.
 */
var CMPUtils = (function () {
    function CMPUtils() {
    }

    var mTplCache = {};
    /**
     * 模版引擎
     * @param str
     * @param data
     * @returns {*|Function}
     */
    CMPUtils.tpl = function (str, data) {
        data = data || {};
        if (str[0] == '#')
            str = $(str).html();
        str = str.toString().trim();
        var fn = mTplCache[str]
            || new Function("o", "var p=[];with(o){p.push('"
            + str.replace(/[\r\t\n]/g, " ").replace(
                /'(?=[^%]*%})/g, "\t").split("'").join("\\'")
                .split("\t").join("'").replace(/{%=(.+?)%}/g,
                "',$1,'").split("{%").join("');")
                .split("%}").join("p.push('")
            + "');}return p.join('');");
        return fn.apply(data, [data]);
    };

    /**
     * 根据模版路径获取模版内容
     * 1.参数传入:
     *     第一种:
     *     basePath:模版文件的基础路径
     *     tplPath : 模版文件的相对路径
     *     第二种:
     *     tplPath : 模版文件的绝对路径
     * @returns {*}
     */
    CMPUtils.getTplContent = function () {
        var tplPath = "";
        var argLen = arguments.length;
        if (argLen == 1) {
            tplPath = arguments[0];
        } else {
            tplPath = arguments[0] + arguments[1];
        }
        return CMPUtils.readFileContent(tplPath);
    };

    /**
     * 根据文件路径读取文件内容
     * @param filePath
     * @returns {*}
     */
    CMPUtils.readFileContent = function (filePath) {
        var readType = arguments[1], content;
        if (!readType) {
            readType = "text";
            content = "";
        }
        $.ajax({
            type    : "GET",
            url     : filePath,
            async   : false, // 设为false就是同步请求
            cache   : false,
            dataType: readType,
            success : function (data) {
                content = data;
            }
        });
        return content;
    };

    return CMPUtils;
})();
//CMPUtils.js e
//CMPChoosePerson.js s
/**
 * Created by Administrator on 2015/3/30 0030.
 */
var CMPOrgConstants = (function () {
    function CMPOrgConstants() {
    }

    CMPOrgConstants.C_sOrgType_Member = "Member";
    CMPOrgConstants.C_sOrgType_Account = "Account";
    CMPOrgConstants.C_sOrgType_Department = "Department";
    CMPOrgConstants.C_sOrgType_Post = "Post";
    CMPOrgConstants.C_sOrgType_Level = "Level";

    CMPOrgConstants.C_iOrgType_Account = 1;
    CMPOrgConstants.C_iOrgType_Department = 2;
    CMPOrgConstants.C_iOrgType_Group = 3;
    CMPOrgConstants.C_iOrgType_Level = 4;
    CMPOrgConstants.C_iOrgType_Member = 5;
    CMPOrgConstants.C_iOrgType_Post = 6;
    CMPOrgConstants.C_iOrgType_Role = 7;
    CMPOrgConstants.C_iOrgType_Team = 8;

    Array.prototype.peek = function () {
        var length = this.length;
        if (length > 0) {
            return this[length - 1];
        } else {
            return undefined;
        }
    };

    return CMPOrgConstants;
})();

var CMPChooseDataUtil = (function () {
    function CMPChooseDataUtil() {
    }

    var idItemSplitChar = ",";
    var typeSplitChar = "|";
    var nameItemSplitChar = "、";

    var _splitStrFunc = function (str, nameStr) {
        if (!str || str == "") return null;
        var arr = str.split(idItemSplitChar);
        var nameArr = nameStr.split(nameItemSplitChar);
        var newArr = [];
        var newObj;
        for (var i = 0, len = arr.length; i < len; i++) {
            newObj = {};
            var selectObjArr = arr[i].split(typeSplitChar);
            var selectType = selectObjArr[0];
            var selectID = selectObjArr[1];
            var selectedName = nameArr[i];
            if (selectType == CMPOrgConstants.C_sOrgType_Member) {
                newObj.type = CMPOrgConstants.C_iOrgType_Member;
                newObj.memberID = selectID;
                newObj.name = selectedName;
                newObj.classType = "MChooseMember";
            } else if (selectType == CMPOrgConstants.C_sOrgType_Department) {
                newObj.type = CMPOrgConstants.C_iOrgType_Department;
                newObj.unitID = selectID;
                newObj.name = selectedName;
                newObj.classType = "MChooseUnit";
            } else if (selectType == CMPOrgConstants.C_sOrgType_Level) {
                newObj.type = MOrgConstants.C_iOrgType_Level;
                newObj.levelID = selectID;
                newObj.name = selectedName;
                newObj.classType = "MChooseLevel";
            } else if (selectType == CMPOrgConstants.C_sOrgType_Post) {
                newObj.type = CMPOrgConstants.C_iOrgType_Post;
                newObj.postID = selectID;
                newObj.name = selectedName;
                newObj.classType = "MChoosePost";
            } else if (selectType == CMPOrgConstants.C_sOrgType_Account) {
                newObj.type = CMPOrgConstants.C_iOrgType_Account;
                newObj.unitID = selectID;
                newObj.name = selectedName;
                newObj.classType = "MChooseUnit";
            }
            newArr.push(newObj);
        }
        return newArr;
    };

    CMPChooseDataUtil.getBackfillData = function (obj) {
        return _splitStrFunc(obj.ids, obj.names);
    };

    return CMPChooseDataUtil;
})();

var CMPChoosePerson = (function () {
    var C_sEvent_TAP = "tap";
    //var C_sEvent_TAP = "click";
    var tplsPath = {
        tpl_for_frame: "/cmp/plugins/new_choose/common/tpl/choose_frame_tpl.html",
        tpl_for_dept_item: "/cmp/plugins/new_choose/tpl/choose_dept_item_for_person_tpl.html",
        tpl_for_check_item: "/cmp/plugins/new_choose/tpl/choose_check_org_item_tpl.html",
        tpl_for_member_item: "/cmp/plugins/new_choose/tpl/choose_member_item_for_person_tpl.html",
        tpl_for_search_item: "/cmp/plugins/new_choose/tpl/choose_member_item_for_search_tpl.html"
    };

    var $frame, _options;
    var frameData = {
        viewID: "cmp_choose_person_view",
        tabs: [
            {
                id: 'cmp_tab_choose_Member',
                type: CMPOrgConstants.C_sOrgType_Member,
                title: "全部人员"
            },
            {
                id: 'cmp_tab_choose_dept',
                type: CMPOrgConstants.C_sOrgType_Department,
                title: "部门"
            }
        ]
    };

    var _scrollMap = {};

    function CMPChoosePerson(el, options) {
        this.container = typeof el == 'object' ? el : document.getElementById(el);
        _options = this.options = {
            basePath: "",
            serverURL: "http://10.5.5.57/seeyon/",
            currentAccountID: "-6234226765708703082",
            fillBackData: null,
            disableData: null,
            filterData:null,
            callback: null,
            closeCallback: null,
            radio:false,
            maxSize: 100
        };
        var i;
        for (i in options) {
            this.options[i] = options[i];
            _options[i] = options[i];
        }

        CMPChoosePerson.basePath = _options.basePath;

        this.initFrameView();
        this.initTabView();
        this.initCheckView();
        if (this.options.fillBackData != null && this.options.fillBackData != "") {
            this.options.fillBackData = CMPChooseDataUtil.getBackfillData(this.options.fillBackData);
        } else {
            this.options.fillBackData = [];
        }
        this.initFillBack();
        this.initData();
        this.initSearchView();

        this.initEvent();
    }

    var getWrapperID = function (id) {
        return id + "_wrapper";
    };

    /* chooseTab 类 */
    var CMPChooseTabMap = {};

    function CMPChooseTab(tabView, scroll, initDataFunc) {
        this.view = tabView;
        this.cmpObj = $.parseJSON(this.view.attr("cmpObj"));
        this.id = this.cmpObj.id;
        this.scroll = scroll;
        this.initData = initDataFunc;
        this.wrapper = $("#" + getWrapperID(this.id));
        CMPChooseTabMap[this.id] = this;
    }

    CMPChooseTab.getTab = function (tabID) {
        return CMPChooseTabMap[tabID];
    };

    CMPChooseTab.prototype.show = function () {
        this.view.siblings().removeClass("cmp_tabs_nav_active");
        this.view.addClass("cmp_tabs_nav_active");
        this.wrapper.siblings(".cmp_wrapper_view").hide();
        var self = this;
        setTimeout(function(){
            self.wrapper.show();
            self.scroll.refresh();
        },100);
        return this;
    };

    CMPChooseTab.prototype.triggerInitData = function () {
        if (this.initData) {
            this.initData(this);
        }
        return this;
    };

    /* chooseTab 类 end */

    var createScroll = function (id, options) {
        if (_scrollMap[id]) return _scrollMap[id];
        var _scrollOptions = {
            hScrollbar: false,
            vScrollbar: false
        };
        var i;
        for (i in options) _scrollOptions[i] = options[i];
        return new iScroll(id, _scrollOptions);
    };

    CMPChoosePerson.prototype.initFrameView = function () {
        var $container = $(this.container);
        $frame = $container.find("#" + frameData.viewID);
        if ($frame.length <= 0) {
            var frameTpl = CMPUtils.getTplContent(this.options.basePath, tplsPath.tpl_for_frame);
            var frameHtml = CMPUtils.tpl(frameTpl, frameData);
            $frame = $(frameHtml);
            $container.append($frame);
        }
        this.open();
    };

    var checkboxClick = function (checkBox, isSearch) {
        var orgObj = $.parseJSON(checkBox.val());
        if (checkBox.is(":checked")) {
            checkBox[0].checked = false;
            checkedView.remove(orgObj);
            if (isSearch) {
                $("#choose_person_for_member_" + orgObj.memberID)[0].checked = false;
                try {
                    $("#choose_person_for_dept_" + orgObj.memberID)[0].checked = false;
                } catch (e) {
                }
            }
        } else {
            checkBox[0].checked = "checked";

            if (_options.radio) {
                checkedView.removeAll();
                $frame.find("input[name=checkbox]:checked").each(function () {
                    $(this)[0].checked = false;
                });
                checkBox[0].checked = "checked";
            } else if (!_options.radio && _options.maxSize != -1 && _options.maxSize != 0 && checkedView.checkedData().length >= _options.maxSize) {
                $.prompt("你只能选择" + _options.maxSize + "个人哦");
                checkBox[0].checked = false;
                return false;
            }
            checkedView.add(orgObj);
            if (isSearch) {
                $("#choose_person_for_member_" + orgObj.memberID)[0].checked = "checked";
                try {
                    $("#choose_person_for_dept_" + orgObj.memberID)[0].checked = "checked";
                } catch (e) {
                }
            }
        }
    };

    var tabInitFunc = function (tab) {
        var param;
        if (tab.wrapper.find(".cmp_list_view").children().length > 0) {
            //_options.disableData = ["-4721486470391116487"];
            tab.wrapper.find(".cmp_list_view input").each(function () {
                var $input = $(this);
                var orgObj = $.parseJSON($input.val());
                if (checkedView.isExist(orgObj)) {
                    $input[0].checked = "checked";
                } else {
                    $input[0].checked = false;
                }
                if (tab.cmpObj.type == CMPOrgConstants.C_sOrgType_Member) {
                    var $span = $input.parent();
                    var $li = $span.parent().parent();
                    if (CMPChoosePerson.checkedDisable(orgObj.memberID)) {
                        $span.addClass("cmp_checkbox_disable");
                        $li.find(".check_link").off(C_sEvent_TAP).removeClass("check_link");
                    } else {
                        $span.removeClass("cmp_checkbox_disable");
                        $li.find(".cmp_list_left").addClass("check_link");
                        $li.find(".cmp_list_center").addClass("check_link");
                        $li.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                            var link = $(this);
                            var checkBox = link.find("input");
                            if (checkBox.length <= 0) {
                                checkBox = link.siblings(".cmp_list_left").find("input");
                            }
                            checkboxClick(checkBox, false);
                        });
                    }
                }
            });
            tab.show();
            return false;
        }
        if (tab.cmpObj.type == CMPOrgConstants.C_sOrgType_Member) {//人员
            param = [_options.currentAccountID, false, true];
            $.post(
                _options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "getMemberListByAccountID",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    var listTpl = CMPUtils.getTplContent(_options.basePath, tplsPath.tpl_for_member_item);
                    var listHtml = CMPUtils.tpl(listTpl, result);
                    var $listHtml = $(listHtml);
                    $listHtml.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                        var link = $(this);
                        var checkBox = link.find("input");
                        if (checkBox.length <= 0) {
                            checkBox = link.siblings(".cmp_list_left").find("input");
                        }
                        checkboxClick(checkBox, false);
                    });
                    tab.wrapper.find(".cmp_list_view").html($listHtml);
                    tab.show();
                }, "json");

        } else if (tab.cmpObj.type == CMPOrgConstants.C_sOrgType_Department) {//部门
            param = [_options.currentAccountID, -1, -1];
            departStack = [];
            $.post(
                _options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "getFirstLayerDepByAccountID",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    departStack.push(result);
                    departTabCallback(tab, result);
                    tab.show();
                }, "json");
        }
    };

    var departStack = [];

    var departmentLoad = function (tab, parentOrg) {
        var param = ["103", _options.currentAccountID, parentOrg.unitID, false, -1, -1];
        $.post(
            _options.serverURL + "ajax.do?method=ajaxAction",
            {
                managerName: "mChoosePersonManager",
                managerMethod: "getOrgByParentID",
                arguments: $.toJSON(param)
            },
            function (result) {
                result.parentOrg = parentOrg;
                departStack.push(result);
                departTabCallback(tab, result);
            },
            "json");
    };

    var departTabCallback = function (tab, result) {
        if (!tab.itemTplContent) {
            tab.itemTplContent = CMPUtils.getTplContent(_options.basePath, tplsPath.tpl_for_dept_item);
        }
        var listHtml = CMPUtils.tpl(tab.itemTplContent, result);
        var $listHtml = $(listHtml);
        $listHtml.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            var link = $(this);
            var checkBox = link.find("input");
            if (checkBox.length <= 0) {
                checkBox = link.siblings(".cmp_list_left").find("input");
            }
            checkboxClick(checkBox, false);
        });
        $listHtml.find(".cmp_next_link").off().on(C_sEvent_TAP, function () {
            var orgObj = $.parseJSON($(this).siblings(".cmp_list_left").find("input").val());
            departmentLoad(tab, orgObj);
        });
        $listHtml.find(".cmp_list_item_btn").off().on(C_sEvent_TAP, function () {
            backPre(tab);
        });
        tab.wrapper.hide();
        tab.wrapper.find(".cmp_list_view").html($listHtml);
        setTimeout(function(){
            tab.wrapper.show();
            tab.scroll.refresh();
        });
    };

    var backPre = function (tab) {
        departStack.pop();
        var result = departStack.peek();
        departTabCallback(tab, result);
    };


    var tabView;

    CMPChoosePerson.prototype.initTabView = function () {
        //var _this = this;
        if (tabView) return;
        tabView = {};
        $frame.find(".cmp_tabs_nav").find("li").each(function () {
            var $tabItem = $(this);
            var tabID = $tabItem.attr("id");
            tabView[tabID] = new CMPChooseTab($tabItem, createScroll(getWrapperID(tabID)), tabInitFunc);

            $tabItem.on(C_sEvent_TAP, function () {
                var tab = CMPChooseTab.getTab(tabID);
                tab.triggerInitData();
            });
        });
    };

    var checkedView = null;

    CMPChoosePerson.prototype.initCheckView = function () {
        var _this = this;
        if (checkedView) return;
        checkedView = {};
        checkedView.tpl = CMPUtils.getTplContent(_options.basePath, tplsPath.tpl_for_check_item);
        checkedView.scroll = createScroll(frameData.viewID + "_footer_wrapper", {
            vScroll: false,
            hScroll: true,
            hScrollbar: false,
            vScrollbar: false
        });
        checkedView.scrollView = $frame.find("#" + frameData.viewID + "_footer_wrapper").find("ul");

        checkedView.add = function (orgObj) {
            var checkHtml = CMPUtils.tpl(checkedView.tpl, [orgObj]);
            checkedView.scrollView.append(checkHtml);
            checkedView.scrollView.width(checkedView.scrollView.width() + 40);
            checkedView.scroll.refresh();
        };

        checkedView.remove = function (orgObj) {
            if (orgObj.classType == "MChooseMember") {
                checkedView.scrollView.find("#checked_org_" + orgObj.memberID).remove();
            } else if (orgObj.classType == "MChooseUnit") {
                checkedView.scrollView.find("#checked_org_" + orgObj.unitID).remove();
            }
            checkedView.scrollView.width(checkedView.scrollView.width() - 40);
            checkedView.scroll.refresh();
        };

        checkedView.removeAll = function () {
            checkedView.scrollView.width(0);
            checkedView.scrollView.html("");
        };

        checkedView.isExist = function (orgObj) {
            var id = "";
            if (orgObj.classType == "MChooseMember") {
                id = orgObj.memberID;
            } else if (orgObj.classType == "MChooseUnit") {
                id = orgObj.unitID;
            }
            return checkedView.scrollView.find("#checked_org_" + id).length > 0;
        };

        checkedView.checkedData = function () {
            var allData = [];
            checkedView.scrollView.children().each(function () {
                allData.push($.parseJSON($(this).attr("cmpObj")));
            });
            return allData;
        };
    };

    CMPChoosePerson.prototype.initFillBack = function () {
        var _this = this;
        var checkHtml = CMPUtils.tpl(checkedView.tpl, _this.options.fillBackData);
        checkedView.scrollView.html(checkHtml);
        checkedView.scrollView.width(checkedView.scrollView.width() + (40 * _this.options.fillBackData.length));
        checkedView.scroll.refresh();
    };

    CMPChoosePerson.isChecked = function (orgObj) {
        return checkedView.isExist(orgObj);
    };

    CMPChoosePerson.checkedDisable = function (orgID) {
        var disableData = _options.disableData;
        if (disableData && disableData !== "" && disableData.length > 0) {
            return $.inArray(orgID, disableData) >= 0;
        }
        return false;
    };

    CMPChoosePerson.filterOrg = function (orgID) {
        var filterData = _options.filterData;
        if(filterData && filterData !== "" && filterData.length > 0){
            return $.inArray(orgID , filterData) >= 0;
        }
        return false;
    };

    var searchView = null;
    CMPChoosePerson.prototype.initSearchView = function () {
        var _this = this;
        if (searchView) return;
        searchView = {};

        searchView.tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_search_item);
        searchView.scroll = createScroll(frameData.viewID + "_search_wrapper");
        searchView.scrollView = $frame.find("#" + frameData.viewID + "_search_wrapper").find(".cmp_list_view");
        searchView.initView = function (result) {
            var searchHtml = CMPUtils.tpl(searchView.tpl, result);
            var $searchHtml = $(searchHtml);
            $searchHtml.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                var link = $(this);
                var checkBox = link.find("input");
                if (checkBox.length <= 0) {
                    checkBox = link.siblings(".cmp_list_left").find("input");
                }
                checkboxClick(checkBox, true);
            });
            searchView.scrollView.html($searchHtml);
            searchView.scroll.refresh();
        };

        searchView.initDataFunc = function (val) {
            var param = [103, _this.options.currentAccountID, val, -1, -1];
            $.post(
                _this.options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "searchMembersByName",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    console.log(result);
                    if (result) {
                        searchView.initView(result);
                    }
                },
                "json"
            );
        }
    };

    CMPChoosePerson.prototype.initData = function () {
        $($frame.find(".cmp_tabs_nav").find("li")[0]).trigger(C_sEvent_TAP);
    };

    CMPChoosePerson.prototype.initEvent = function () {
        var _this = this;
        var search_head_view = $frame.find(".cmp_search_head_view");
        var search_btn_head_view = $frame.find(".cmp_search_btn_head_view");
        var shad_view = $frame.find(".cmp_shade_view");
        var page_content_view = $frame.find(".cmp_page_content_view");
        var search_view = $frame.find("#" + frameData.viewID + "_search_wrapper");
        $frame.find(".cmp_search_btn_view").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            search_btn_head_view.hide();
            page_content_view.addClass("search");
            search_head_view.show();
            shad_view.show();
            search_head_view.find("#cmp_search_input").focus();
            return false;
        });

        $frame.find(".cmp_search_cancel").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            search_head_view.hide();
            shad_view.hide();
            search_view.hide();
            page_content_view.removeClass("search");
            search_btn_head_view.show();
            search_head_view.find("#cmp_search_input").val("");
            return false;
        });
        $frame.find(".cmp_page_header_back").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            _this.close();
            return false;
        });


        $frame.find(".cmp_footer_right").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            if (_this.options.callback) {
                _this.options.callback(checkedView.checkedData());
            }
            _this.close();
            return false;
        });

        search_head_view.find("#cmp_search_input").off(C_sEvent_TAP).on("input", function () {
            var value = $(this).val();
            shad_view.hide();
            search_view.show();
            searchView.initDataFunc(value);
        });

    };

    CMPChoosePerson.prototype.open = function () {
        $frame.show();
        $frame.addClass("cmp_choose_active");
    };

    CMPChoosePerson.prototype.close = function () {
        var _this = this;
        var search_head_view = $frame.find(".cmp_search_head_view");
        var search_btn_head_view = $frame.find(".cmp_search_btn_head_view");
        var shad_view = $frame.find(".cmp_shade_view");
        var search_view = $frame.find("#" + frameData.viewID + "_search_wrapper");
        var page_content_view = $frame.find(".cmp_page_content_view");
        search_head_view.hide();
        shad_view.hide();
        search_view.hide();
        search_btn_head_view.show();
        search_head_view.find("#cmp_search_input").val("");
        page_content_view.removeClass("search");
        $frame.removeClass("cmp_choose_active");
        $frame.hide();
        checkedView.scrollView.html("");
        checkedView.scrollView.width(0);
        checkedView.scroll.refresh();
        if (_this.options.closeCallback) {
            _this.options.closeCallback();
        }
    };

    return CMPChoosePerson;
})();
//CMPChoosePerson.js e
//CMPChooseDept.js s
var CMPChooseDept = (function () {
    var C_sEvent_TAP = "tap";
    //var C_sEvent_TAP = "click";

    var tplsPath = {
        tpl_for_frame: "/cmp/plugins/new_choose/common/tpl/choose_frame_two_tpl.html",
        tpl_for_dept_item: "/cmp/plugins/new_choose/tpl/choose_dept_item_for_dept_tpl.html",
        tpl_for_check_item: "/cmp/plugins/new_choose/tpl/choose_check_org_item_tpl.html"
    };

    var frameData = {
        viewID: "cmp_choose_dept_view",
        type: CMPOrgConstants.C_sOrgType_Department,
        title: "选择部门"
    };

    var $frame, maxSize = 1;

    function CMPChooseDept(el, options) {

        this.container = typeof el == 'object' ? el : document.getElementById(el);
        this.options = {
            basePath: "",
            serverURL: "http://10.5.5.57/seeyon/",
            currentAccountID: "-6234226765708703082",
            currentAccountName:"北京致远",
            fillBackData: null,
            maxSize: maxSize,
            closeCallback: null,
            callback: null
        };
        var i;
        for (i in options) {
            this.options[i] = options[i];
        }

        maxSize = this.options.maxSize;
        frameData.currentAccountName = this.options.currentAccountName;

        this.initFrameView();

        this.initDeptView();

        this.initCheckView();

        if (this.options.fillBackData != null && this.options.fillBackData != "") {
            this.options.fillBackData = CMPChooseDataUtil.getBackfillData(this.options.fillBackData);
        } else {
            this.options.fillBackData = [];
        }

        this.initFillBack();

        this.initEvent();
        this.initData();
    }

    CMPChooseDept.prototype.initFrameView = function () {
        var $container = $(this.container);
        $frame = $container.find("#" + frameData.viewID);
        if ($frame.length <= 0) {
            var frameTpl = CMPUtils.getTplContent(this.options.basePath, tplsPath.tpl_for_frame);
            var frameHtml = CMPUtils.tpl(frameTpl, frameData);
            $frame = $(frameHtml);
            $container.append($frame);
        }
        this.open();
    };

    var C_sChooseView_Dept = "chooseViewDept";
    var C_sChooseView_Check = "chooseViewCheck";

    var ChooseView = {};
    var departStack = [];

    var checkboxClick = function (checkBox) {
        var orgObj = $.parseJSON(checkBox.val());
        if (checkBox.is(":checked")) {
            checkBox[0].checked = false;
            ChooseView[C_sChooseView_Check].remove(orgObj);
        } else {
            checkBox[0].checked = "checked";
            if (maxSize == 1) {
                ChooseView[C_sChooseView_Check].removeAll();
                $frame.find("input[name=checkbox]:checked").each(function () {
                    $(this)[0].checked = false;
                });
                checkBox[0].checked = "checked";
            } else if (maxSize > 1 && ChooseView[C_sChooseView_Check].getCheckedData().length >= maxSize) {
                $.prompt("选择不能超过" + maxSize + "个部门");
                checkBox[0].checked = false;
                return false;
            }
            ChooseView[C_sChooseView_Check].add(orgObj);
        }
    };

    CMPChooseDept.prototype.initDeptView = function () {
        var _this = this;
        departStack = [];
        if (ChooseView[C_sChooseView_Dept]) return;
        ChooseView[C_sChooseView_Dept] = {};

        ChooseView[C_sChooseView_Dept].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_dept_item);

        ChooseView[C_sChooseView_Dept].scroll = new iScroll(frameData.viewID + "_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Dept].scrollView = $frame.find("#" + frameData.viewID + "_wrapper").find(".cmp_list_view");

        ChooseView[C_sChooseView_Dept].initView = function (result) {
            if (result.parentID == -1) {
                $frame.find(".cmp_small_header_back_btn").hide();
            } else {
                $frame.find(".cmp_small_header_back_btn").show();
            }
            $frame.find(".cmp_small_header_back_btn").off().on(C_sEvent_TAP, function () {
                backPre();
            });
            var listHTML = CMPUtils.tpl(ChooseView[C_sChooseView_Dept].tpl, result);
            var $listHTML = $(listHTML);
            $listHTML.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                var link = $(this);
                var checkBox = link.find("input");
                if (checkBox.length <= 0) {
                    checkBox = link.siblings(".cmp_list_left").find("input");
                }
                checkboxClick(checkBox);
            });
            $listHTML.find(".cmp_next_link").each(function () {
                $(this).off().on(C_sEvent_TAP, function () {
                    var orgObj = $.parseJSON($(this).siblings(".cmp_list_left").find("input").val());
                    ChooseView[C_sChooseView_Dept].initDataFunc(orgObj.unitID);
                });
            });
            ChooseView[C_sChooseView_Dept].scrollView.html($listHTML);
            ChooseView[C_sChooseView_Dept].scroll.refresh();
        };

        ChooseView[C_sChooseView_Dept].initDataFunc = function (parentID) {
            var param = [_this.options.currentAccountID, parentID, (parentID == -1), -1, -1];
            $.post(
                _this.options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "getDeparmentList",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    result.parentID = parentID;
                    departStack.push(result);
                    ChooseView[C_sChooseView_Dept].initView(result);
                },
                "json"
            );
        };
    };

    CMPChooseDept.prototype.initCheckView = function () {
        var _this = this;
        if (ChooseView[C_sChooseView_Check]) return;
        ChooseView[C_sChooseView_Check] = {};

        ChooseView[C_sChooseView_Check].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_check_item);

        ChooseView[C_sChooseView_Check].scroll = new iScroll(frameData.viewID + "_footer_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Check].scrollView = $frame.find("#" + frameData.viewID + "_footer_wrapper").find("ul");

        ChooseView[C_sChooseView_Check].add = function (orgObj) {
            var itemHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, [orgObj]);
            ChooseView[C_sChooseView_Check].scrollView.append(itemHtml);
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].remove = function (orgObj) {
            ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.unitID).remove();
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() - 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].removeAll = function () {
            ChooseView[C_sChooseView_Check].scrollView.width(0);
            ChooseView[C_sChooseView_Check].scrollView.html("");
        };

        ChooseView[C_sChooseView_Check].getCheckedData = function () {
            var checkedData = [];
            ChooseView[C_sChooseView_Check].scrollView.children().each(function () {
                checkedData.push($.parseJSON($(this).attr("cmpObj")));
            });
            return checkedData;
        };
    };

    CMPChooseDept.prototype.initFillBack = function () {
        var _this = this;
        var checkHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, _this.options.fillBackData);
        ChooseView[C_sChooseView_Check].scrollView.html(checkHtml);
        ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + (40 * _this.options.fillBackData.length));
        ChooseView[C_sChooseView_Check].scroll.refresh();
    };

    CMPChooseDept.isChecked = function (orgObj) {
        return ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.unitID).length > 0;
    };

    var backPre = function () {
        departStack.pop();
        var orgResult = departStack.peek();
        ChooseView[C_sChooseView_Dept].initView(orgResult);
    };

    CMPChooseDept.prototype.initData = function () {
        ChooseView[C_sChooseView_Dept].initDataFunc(-1);
    };

    CMPChooseDept.prototype.initEvent = function () {
        var _this = this;
        $frame.find(".cmp_footer_right").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            if (_this.options.callback) {
                _this.options.callback(ChooseView[C_sChooseView_Check].getCheckedData());
            }
            _this.close();
            return false;
        });
        $frame.find(".cmp_page_header_back").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            _this.close();
            return false;
        });
    };

    CMPChooseDept.prototype.open = function () {
        $frame.show();
        $frame.addClass("cmp_choose_active");
    };

    CMPChooseDept.prototype.close = function () {
        var _this = this;
        $frame.removeClass("cmp_choose_active");
        $frame.hide();
        ChooseView[C_sChooseView_Check].scrollView.html("");
        ChooseView[C_sChooseView_Check].scrollView.width(0);
        ChooseView[C_sChooseView_Check].scroll.refresh();
        if (_this.options.closeCallback) {
            _this.options.closeCallback();
        }
    };


    return CMPChooseDept;
})();
//CMPChooseDept.js e
//CMPChooseLevel.js
var CMPChooseLevel = (function () {

    var C_sEvent_TAP = "tap";
    //var C_sEvent_TAP = "click";

    var tplsPath = {
        tpl_for_frame: "/cmp/plugins/new_choose/common/tpl/choose_frame_two_tpl.html",
        tpl_for_level_item: "/cmp/plugins/new_choose/tpl/choose_level_item_for_level_tpl.html",
        tpl_for_check_item: "/cmp/plugins/new_choose/tpl/choose_check_org_item_tpl.html"
    };

    var frameData = {
        viewID: "cmp_choose_level_view",
        type: CMPOrgConstants.C_sOrgType_Level,
        title: "选择职务级别"
    };

    var $frame, maxSize = 1;

    function CMPChooseLevel(el, options) {

        this.container = typeof el == 'object' ? el : document.getElementById(el);
        this.options = {
            basePath: "",
            serverURL: "http://10.5.5.57/seeyon/",
            currentAccountID: "-6234226765708703082",
            currentAccountName:"北京致远",
            fillBackData: null,
            maxSize: maxSize,
            closeCallback: null,
            callback: null
        };
        var i;
        for (i in options) {
            this.options[i] = options[i];
        }

        maxSize = this.options.maxSize;
        frameData.currentAccountName = this.options.currentAccountName;

        this.initFrameView();

        this.initLevelView();

        this.initCheckView();

        if (this.options.fillBackData != null && this.options.fillBackData != "") {
            this.options.fillBackData = CMPChooseDataUtil.getBackfillData(this.options.fillBackData);
        } else {
            this.options.fillBackData = [];
        }

        this.initFillBack();

        this.initEvent();
        this.initData();
    }

    CMPChooseLevel.prototype.initFrameView = function () {
        var $container = $(this.container);
        $frame = $container.find("#" + frameData.viewID);
        if ($frame.length <= 0) {
            var frameTpl = CMPUtils.getTplContent(this.options.basePath, tplsPath.tpl_for_frame);
            var frameHtml = CMPUtils.tpl(frameTpl, frameData);
            $frame = $(frameHtml);
            $container.append($frame);
        }
        this.open();
    };

    var C_sChooseView_Level = "chooseViewLevel";
    var C_sChooseView_Check = "chooseViewCheck";

    var checkboxClick = function (checkBox) {
        var orgObj = $.parseJSON(checkBox.val());
        if (checkBox.is(":checked")) {
            checkBox[0].checked = false;
            ChooseView[C_sChooseView_Check].remove(orgObj);
        } else {
            checkBox[0].checked = "checked";
            if (maxSize == 1) {
                ChooseView[C_sChooseView_Check].removeAll();
                $frame.find("input[name=checkbox]:checked").each(function () {
                    $(this)[0].checked = false;
                });
                checkBox[0].checked = "checked";
            } else if (maxSize > 1 && ChooseView[C_sChooseView_Check].getCheckedData().length >= maxSize) {
                $.prompt("选择不能超过" + maxSize + "个职务级别");
                checkBox[0].checked = false;
                return false;
            }
            ChooseView[C_sChooseView_Check].add(orgObj);
        }
    };

    var ChooseView = {};
    CMPChooseLevel.prototype.initLevelView = function () {
        var _this = this;
        if (ChooseView[C_sChooseView_Level]) return;
        ChooseView[C_sChooseView_Level] = {};

        ChooseView[C_sChooseView_Level].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_level_item);

        ChooseView[C_sChooseView_Level].scroll = new iScroll(frameData.viewID + "_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Level].scrollView = $frame.find("#" + frameData.viewID + "_wrapper").find(".cmp_list_view");

        ChooseView[C_sChooseView_Level].initView = function (result) {
            $frame.find(".cmp_small_header_back_btn").hide();

            var listHTML = CMPUtils.tpl(ChooseView[C_sChooseView_Level].tpl, result);
            var $listHTML = $(listHTML);
            $listHTML.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                var link = $(this);
                var checkBox = link.find("input");
                if (checkBox.length <= 0) {
                    checkBox = link.siblings(".cmp_list_left").find("input");
                }
                checkboxClick(checkBox);
            });
            ChooseView[C_sChooseView_Level].scrollView.html($listHTML);
            ChooseView[C_sChooseView_Level].scroll.refresh();
        };

        ChooseView[C_sChooseView_Level].initDataFunc = function () {
            var param = [_this.options.currentAccountID, -1, -1];
            $.post(
                _this.options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "getLevelList",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    ChooseView[C_sChooseView_Level].initView(result);
                },
                "json"
            );
        };
    };

    CMPChooseLevel.prototype.initCheckView = function () {
        var _this = this;
        if (ChooseView[C_sChooseView_Check]) return;
        ChooseView[C_sChooseView_Check] = {};

        ChooseView[C_sChooseView_Check].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_check_item);

        ChooseView[C_sChooseView_Check].scroll = new iScroll(frameData.viewID + "_footer_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Check].scrollView = $frame.find("#" + frameData.viewID + "_footer_wrapper").find("ul");

        ChooseView[C_sChooseView_Check].add = function (orgObj) {
            var itemHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, [orgObj]);
            ChooseView[C_sChooseView_Check].scrollView.append(itemHtml);
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].remove = function (orgObj) {
            ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.levelID).remove();
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() - 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].removeAll = function () {
            ChooseView[C_sChooseView_Check].scrollView.width(0);
            ChooseView[C_sChooseView_Check].scrollView.html("");
        };

        ChooseView[C_sChooseView_Check].getCheckedData = function () {
            var checkedData = [];
            ChooseView[C_sChooseView_Check].scrollView.children().each(function () {
                checkedData.push($.parseJSON($(this).attr("cmpObj")));
            });
            return checkedData;
        };
    };

    CMPChooseLevel.prototype.initFillBack = function () {
        var _this = this;
        var checkHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, _this.options.fillBackData);
        ChooseView[C_sChooseView_Check].scrollView.html(checkHtml);
        ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + (40 * _this.options.fillBackData.length));
        ChooseView[C_sChooseView_Check].scroll.refresh();
    };

    CMPChooseLevel.isChecked = function (orgObj) {
        return ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.levelID).length > 0;
    };

    CMPChooseLevel.prototype.initData = function () {
        ChooseView[C_sChooseView_Level].initDataFunc();
    };

    CMPChooseLevel.prototype.initEvent = function () {
        var _this = this;
        $frame.find(".cmp_footer_right").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            if (_this.options.callback) {
                _this.options.callback(ChooseView[C_sChooseView_Check].getCheckedData());
            }
            _this.close();
            return false;
        });
        $frame.find(".cmp_page_header_back").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            _this.close();
            return false;
        });
    };

    CMPChooseLevel.prototype.open = function () {
        $frame.show();
        $frame.addClass("cmp_choose_active");
    };

    CMPChooseLevel.prototype.close = function () {
        var _this = this;
        $frame.removeClass("cmp_choose_active");
        $frame.hide();
        ChooseView[C_sChooseView_Check].scrollView.html("");
        ChooseView[C_sChooseView_Check].scrollView.width(0);
        ChooseView[C_sChooseView_Check].scroll.refresh();
        if (_this.options.closeCallback) {
            _this.options.closeCallback();
        }
    };


    return CMPChooseLevel;
})();
//CMPChooseLevel.js e
//CMPChoosePost.js s
var CMPChoosePost = (function () {

    var C_sEvent_TAP = "tap";
    //var C_sEvent_TAP = "click";

    var tplsPath = {
        tpl_for_frame: "/cmp/plugins/new_choose/common/tpl/choose_frame_two_tpl.html",
        tpl_for_post_item: "/cmp/plugins/new_choose/tpl/choose_post_item_for_post_tpl.html",
        tpl_for_check_item: "/cmp/plugins/new_choose/tpl/choose_check_org_item_tpl.html"
    };

    var frameData = {
        viewID: "cmp_choose_post_view",
        type: CMPOrgConstants.C_sOrgType_Post,
        title: "选择岗位"
    };

    var $frame;

    var maxSize = 1;

    function CMPChoosePost(el, options) {

        this.container = typeof el == 'object' ? el : document.getElementById(el);
        this.options = {
            basePath: "",
            serverURL: "http://10.5.5.57/seeyon/",
            currentAccountID: "-6234226765708703082",
            currentAccountName:"北京致远",
            fillBackData: null,
            maxSize: maxSize,
            callback: null,
            closeCallback: null
        };
        var i;
        for (i in options) {
            this.options[i] = options[i];
        }

        maxSize = this.options.maxSize;
        frameData.currentAccountName = this.options.currentAccountName;

        this.initFrameView();

        this.initPostView();

        this.initCheckView();

        if (this.options.fillBackData != null && this.options.fillBackData != "") {
            this.options.fillBackData = CMPChooseDataUtil.getBackfillData(this.options.fillBackData);
        } else {
            this.options.fillBackData = [];
        }

        this.initFillBack();

        this.initEvent();
        this.initData();
    }

    CMPChoosePost.prototype.initFrameView = function () {
        var $container = $(this.container);
        $frame = $container.find("#" + frameData.viewID);
        if ($frame.length <= 0) {
            var frameTpl = CMPUtils.getTplContent(this.options.basePath, tplsPath.tpl_for_frame);
            var frameHtml = CMPUtils.tpl(frameTpl, frameData);
            $frame = $(frameHtml);
            $container.append($frame);
        }
        this.open();
    };

    var C_sChooseView_Post = "chooseViewPost";
    var C_sChooseView_Check = "chooseViewCheck";

    var checkboxClick = function (checkBox) {
        var orgObj = $.parseJSON(checkBox.val());
        if (checkBox.is(":checked")) {
            checkBox[0].checked = false;
            ChooseView[C_sChooseView_Check].remove(orgObj);
        } else {
            checkBox[0].checked = "checked";
            if (maxSize == 1) {
                ChooseView[C_sChooseView_Check].removeAll();
                $frame.find("input[name=checkbox]:checked").each(function () {
                    $(this)[0].checked = false;
                });
                checkBox[0].checked = "checked";
            } else if (maxSize > 1 && ChooseView[C_sChooseView_Check].getCheckedData().length >= maxSize) {
                $.prompt("选择不能超过" + maxSize + "岗位");
                checkBox[0].checked = false;
                return false;
            }
            ChooseView[C_sChooseView_Check].add(orgObj);
        }
    };

    var ChooseView = {};
    CMPChoosePost.prototype.initPostView = function () {
        var _this = this;
        if (ChooseView[C_sChooseView_Post]) return;
        ChooseView[C_sChooseView_Post] = {};

        ChooseView[C_sChooseView_Post].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_post_item);

        ChooseView[C_sChooseView_Post].scroll = new iScroll(frameData.viewID + "_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Post].scrollView = $frame.find("#" + frameData.viewID + "_wrapper").find(".cmp_list_view");

        ChooseView[C_sChooseView_Post].initView = function (result) {
            $frame.find(".cmp_small_header_back_btn").hide();

            var listHTML = CMPUtils.tpl(ChooseView[C_sChooseView_Post].tpl, result);
            var $listHTML = $(listHTML);
            $listHTML.find(".check_link").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
                var link = $(this);
                var checkBox = link.find("input");
                if (checkBox.length <= 0) {
                    checkBox = link.siblings(".cmp_list_left").find("input");
                }
                checkboxClick(checkBox);
            });
            ChooseView[C_sChooseView_Post].scrollView.html($listHTML);
            ChooseView[C_sChooseView_Post].scroll.refresh();
        };

        ChooseView[C_sChooseView_Post].initDataFunc = function () {
            var param = [_this.options.currentAccountID, -1, -1];
            $.post(
                _this.options.serverURL + "ajax.do?method=ajaxAction",
                {
                    managerName: "mChoosePersonManager",
                    managerMethod: "getPostList",
                    arguments: $.toJSON(param)
                },
                function (result) {
                    ChooseView[C_sChooseView_Post].initView(result);
                },
                "json"
            );
        };
    };

    CMPChoosePost.prototype.initCheckView = function () {
        var _this = this;
        if (ChooseView[C_sChooseView_Check]) return;
        ChooseView[C_sChooseView_Check] = {};

        ChooseView[C_sChooseView_Check].tpl = CMPUtils.getTplContent(_this.options.basePath, tplsPath.tpl_for_check_item);

        ChooseView[C_sChooseView_Check].scroll = new iScroll(frameData.viewID + "_footer_wrapper", {
            hScrollbar: false,
            vScrollbar: false
        });

        ChooseView[C_sChooseView_Check].scrollView = $frame.find("#" + frameData.viewID + "_footer_wrapper").find("ul");

        ChooseView[C_sChooseView_Check].add = function (orgObj) {
            var itemHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, [orgObj]);
            ChooseView[C_sChooseView_Check].scrollView.append(itemHtml);
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].remove = function (orgObj) {
            ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.postID).remove();
            ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() - 40);
            ChooseView[C_sChooseView_Check].scroll.refresh();
        };

        ChooseView[C_sChooseView_Check].removeAll = function () {
            ChooseView[C_sChooseView_Check].scrollView.width(0);
            ChooseView[C_sChooseView_Check].scrollView.html("");
        };

        ChooseView[C_sChooseView_Check].getCheckedData = function () {
            var checkedData = [];
            ChooseView[C_sChooseView_Check].scrollView.children().each(function () {
                checkedData.push($.parseJSON($(this).attr("cmpObj")));
            });
            return checkedData;
        };
    };

    CMPChoosePost.prototype.initFillBack = function () {
        var _this = this;
        var checkHtml = CMPUtils.tpl(ChooseView[C_sChooseView_Check].tpl, _this.options.fillBackData);
        ChooseView[C_sChooseView_Check].scrollView.html(checkHtml);
        ChooseView[C_sChooseView_Check].scrollView.width(ChooseView[C_sChooseView_Check].scrollView.width() + (40 * _this.options.fillBackData.length));
        ChooseView[C_sChooseView_Check].scroll.refresh();
    };

    CMPChoosePost.isChecked = function (orgObj) {
        return ChooseView[C_sChooseView_Check].scrollView.find("#checked_org_" + orgObj.postID).length > 0;
    };

    CMPChoosePost.prototype.initData = function () {
        ChooseView[C_sChooseView_Post].initDataFunc();
    };

    CMPChoosePost.prototype.initEvent = function () {
        var _this = this;
        $frame.find(".cmp_footer_right").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            if (_this.options.callback) {
                _this.options.callback(ChooseView[C_sChooseView_Check].getCheckedData());
            }
            _this.close();
            return false;
        });
        $frame.find(".cmp_page_header_back").off(C_sEvent_TAP).on(C_sEvent_TAP, function () {
            _this.close();
            return false;
        });
    };

    CMPChoosePost.prototype.open = function () {
        $frame.show();
        $frame.addClass("cmp_choose_active");
    };

    CMPChoosePost.prototype.close = function () {
        var _this = this;
        $frame.removeClass("cmp_choose_active");
        $frame.hide();
        ChooseView[C_sChooseView_Check].scrollView.html("");
        ChooseView[C_sChooseView_Check].scrollView.width(0);
        ChooseView[C_sChooseView_Check].scroll.refresh();
        if (_this.options.closeCallback) {
            _this.options.closeCallback();
        }
    };


    return CMPChoosePost;
})
();
//CMPChoosePost.js e
//MCalendar.js s
/*jslint eqeq: true, plusplus: true, undef: true, sloppy: true, vars: true, forin: true */
/*!
 * jQuery MobiScroll v2.5.1
 * http://mobiscroll.com
 *
 * Copyright 2010-2013, Acid Media
 * Licensed under the MIT license.
 *
 */
(function ($) {

    function Scroller(elem, settings) {
        var m,
            hi,
            v,
            dw,
            ww, // Window width
            wh, // Window height
            rwh,
            mw, // Modal width
            mh, // Modal height
            anim,
            debounce,
            that = this,
            ms = $.mobiscroll,
            e = elem,
            elm = $(e),
            theme,
            lang,
            s = extend({}, defaults),
            pres = {},
            warr = [],
            iv = {},
            pixels = {},
            input = elm.is('input'),
            visible = false;

        // Private functions

        function isReadOnly(wh) {
            if ($.isArray(s.readonly)) {
                var i = $('.dwwl', dw).index(wh);
                return s.readonly[i];
            }
            return s.readonly;
        }

        function generateWheelItems(i) {
            var html = '<div class="dw-bf">',
                l = 1,
                j;

            for (j in warr[i]) {
                if (l % 20 == 0) {
                    html += '</div><div class="dw-bf">';
                }
                html += '<div class="dw-li dw-v" data-val="' + j + '" style="height:' + hi + 'px;line-height:' + hi + 'px;"><div class="dw-i" style="font-size: 26px;">' + warr[i][j] + '</div></div>';
                l++;
            }
            html += '</div>';
            return html;
        }

        function setGlobals(t) {
            min = $('.dw-li', t).index($('.dw-v', t).eq(0));
            max = $('.dw-li', t).index($('.dw-v', t).eq(-1));
            index = $('.dw-ul', dw).index(t);
            h = hi;
            inst = that;
        }

        function formatHeader(v) {
            var t = s.headerText;
            return t ? (typeof t === 'function' ? t.call(e, v) : t.replace(/\{value\}/i, v)) : '';
        }

        function read() {
            that.temp = ((input && that.val !== null && that.val != elm.val()) || that.values === null) ? s.parseValue(elm.val() || '', that) : that.values.slice(0);
            that.setValue(true);
        }

        function scrollToPos(time, index, manual, dir, orig) {

            // Call validation event
            if (event('validate', [dw, index, time]) !== false) {

                // Set scrollers to position
                $('.dw-ul', dw).each(function (i) {
                    var t = $(this),
                        cell = $('.dw-li[data-val="' + that.temp[i] + '"]', t),
                        cells = $('.dw-li', t),
                        v = cells.index(cell),
                        l = cells.length,
                        sc = i == index || index === undefined;

                    // Scroll to a valid cell
                    if (!cell.hasClass('dw-v')) {
                        var cell1 = cell,
                            cell2 = cell,
                            dist1 = 0,
                            dist2 = 0;

                        while (v - dist1 >= 0 && !cell1.hasClass('dw-v')) {
                            dist1++;
                            cell1 = cells.eq(v - dist1);
                        }

                        while (v + dist2 < l && !cell2.hasClass('dw-v')) {
                            dist2++;
                            cell2 = cells.eq(v + dist2);
                        }

                        // If we have direction (+/- or mouse wheel), the distance does not count
                        if (((dist2 < dist1 && dist2 && dir !== 2) || !dist1 || (v - dist1 < 0) || dir == 1) && cell2.hasClass('dw-v')) {
                            cell = cell2;
                            v = v + dist2;
                        } else {
                            cell = cell1;
                            v = v - dist1;
                        }
                    }

                    if (!(cell.hasClass('dw-sel')) || sc) {
                        // Set valid value
                        that.temp[i] = cell.attr('data-val');

                        // Add selected class to cell
                        $('.dw-sel', t).removeClass('dw-sel');
                        cell.addClass('dw-sel');

                        // Scroll to position
                        //that.scroll(t, i, v, time);
                        that.scroll(t, i, v, sc ? time : 0.1, sc ? orig : undefined);
                    }
                });

                // Reformat value if validation changed something
                that.change(manual);
            }

        }

        function position(check) {

            if (s.display == 'inline' || (ww === $(window).width() && rwh === $(window).height() && check)) {
                return;
            }

            var w,
                l,
                t,
                aw, // anchor width
                ah, // anchor height
                ap, // anchor position
                at, // anchor top
                al, // anchor left
                arr, // arrow
                arrw, // arrow width
                arrl, // arrow left
                scroll,
                totalw = 0,
                minw = 0,
                st = $(window).scrollTop(),
                wr = $('.dwwr', dw),
                d = $('.dw', dw),
                css = {},
                anchor = s.anchor === undefined ? elm : s.anchor;

            ww = $(window).width();
            rwh = $(window).height();
            wh = window.innerHeight; // on iOS we need innerHeight
            wh = wh || rwh;

            if (/modal|bubble/.test(s.display)) {
                $('.dwc', dw).each(function () {
                    w = $(this).outerWidth(true);
                    totalw += w;
                    minw = (w > minw) ? w : minw;
                });
                w = totalw > ww ? minw : totalw;
                wr.width(w);
            }

            mw = d.outerWidth();
            mh = d.outerHeight(true);

            if (s.display == 'modal') {
                l = (ww - mw) / 2;
                t = st + (wh - mh) / 2;
            } else if (s.display == 'bubble') {
                scroll = true;
                arr = $('.dw-arrw-i', dw);
                ap = anchor.offset();
                at = ap.top;
                al = ap.left;

                // horizontal positioning
                aw = anchor.outerWidth();
                ah = anchor.outerHeight();
                l = al - (d.outerWidth(true) - aw) / 2;
                l = l > (ww - mw) ? (ww - (mw + 20)) : l;
                l = l >= 0 ? l : 20;

                // vertical positioning
                t = at - mh; //(mh + 3); // above the input
                if ((t < st) || (at > st + wh)) { // if doesn't fit above or the input is out of the screen
                    d.removeClass('dw-bubble-top').addClass('dw-bubble-bottom');
                    t = at + ah;// + 3; // below the input
                } else {
                    d.removeClass('dw-bubble-bottom').addClass('dw-bubble-top');
                }

                //t = t >= st ? t : st;

                // Calculate Arrow position
                arrw = arr.outerWidth();
                arrl = al + aw / 2 - (l + (mw - arrw) / 2);

                // Limit Arrow position to [0, pocw.width] intervall
                $('.dw-arr', dw).css({ left: arrl > arrw ? arrw : arrl });
            } else {
                css.width = '100%';
                if (s.display == 'top') {
                    t = st;
                } else if (s.display == 'bottom') {
                    t = st + wh - mh;
                }
            }

            css.top = t < 0 ? 0 : t;
            css.left = l;
            d.css(css);

            // If top + modal height > doc height, increase doc height
            $('.dw-persp', dw).height(0).height(t + mh > $(document).height() ? t + mh : $(document).height());

            // Scroll needed
            if (scroll && ((t + mh > st + wh) || (at > st + wh))) {
                $(window).scrollTop(t + mh - wh);
            }
        }

        function testTouch(e) {
            if (e.type === 'touchstart') {
                touch = true;
                setTimeout(function () {
                    touch = false; // Reset if mouse event was not fired
                }, 500);
            } else if (touch) {
                touch = false;
                return false;
            }
            return true;
        }

        function event(name, args) {
            var ret;
            args.push(that);
            $.each([theme.defaults, pres, settings], function (i, v) {
                if (v[name]) { // Call preset event
                    ret = v[name].apply(e, args);
                }
            });
            return ret;
        }

        function plus(t) {
            var p = +t.data('pos'),
                val = p + 1;
            calc(t, val > max ? min : val, 1, true);
        }

        function minus(t) {
            var p = +t.data('pos'),
                val = p - 1;
            calc(t, val < min ? max : val, 2, true);
        }

        // Public functions

        /**
        * Enables the scroller and the associated input.
        */
        that.enable = function () {
            s.disabled = false;
            if (input) {
                elm.prop('disabled', false);
            }
        };

        /**
        * Disables the scroller and the associated input.
        */
        that.disable = function () {
            s.disabled = true;
            if (input) {
                elm.prop('disabled', true);
            }
        };

        /**
        * Scrolls target to the specified position
        * @param {Object} t - Target wheel jQuery object.
        * @param {Number} index - Index of the changed wheel.
        * @param {Number} val - Value.
        * @param {Number} time - Duration of the animation, optional.
        * @param {Number} orig - Original value.
        */
        that.scroll = function (t, index, val, time, orig) {

            function getVal(t, b, c, d) {
                return c * Math.sin(t / d * (Math.PI / 2)) + b;
            }

            function ready() {
                clearInterval(iv[index]);
                delete iv[index];
                t.data('pos', val).closest('.dwwl').removeClass('dwa');
            }

            var px = (m - val) * hi,
                i;

            if (px == pixels[index] && iv[index]) {
                return;
            }

            if (time && px != pixels[index]) {
                // Trigger animation start event
                event('onAnimStart', [dw, index, time]);
            }

            pixels[index] = px;

            t.attr('style', (prefix + '-transition:all ' + (time ? time.toFixed(3) : 0) + 's ease-out;') + (has3d ? (prefix + '-transform:translate3d(0,' + px + 'px,0);') : ('top:' + px + 'px;')));

            if (iv[index]) {
                ready();
            }

            if (time && orig !== undefined) {
                i = 0;
                t.closest('.dwwl').addClass('dwa');
                iv[index] = setInterval(function () {
                    i += 0.1;
                    t.data('pos', Math.round(getVal(i, orig, val - orig, time)));
                    if (i >= time) {
                        ready();
                    }
                }, 100);
            } else {
                t.data('pos', val);
            }
        };

        /**
        * Gets the selected wheel values, formats it, and set the value of the scroller instance.
        * If input parameter is true, populates the associated input element.
        * @param {Boolean} sc - Scroll the wheel in position.
        * @param {Boolean} fill - Also set the value of the associated input element. Default is true.
        * @param {Number} time - Animation time
        * @param {Boolean} temp - If true, then only set the temporary value.(only scroll there but not set the value)
        */
        that.setValue = function (sc, fill, time, temp) {
            if (!$.isArray(that.temp)) {
                that.temp = s.parseValue(that.temp + '', that);
            }

            if (visible && sc) {
                scrollToPos(time);
            }

            v = s.formatResult(that.temp);

            if (!temp) {
                that.values = that.temp.slice(0);
                that.val = v;
            }

            if (fill) {
                if (input) {
                    elm.val(v).trigger('change');
                }
            }
        };

        that.getValues = function () {
            var ret = [],
                i;

            for (i in that._selectedValues) {
                ret.push(that._selectedValues[i]);
            }
            return ret;
        };

        /**
        * Checks if the current selected values are valid together.
        * In case of date presets it checks the number of days in a month.
        * @param {Number} time - Animation time
        * @param {Number} orig - Original value
        * @param {Number} i - Currently changed wheel index, -1 if initial validation.
        * @param {Number} dir - Scroll direction
        */
        that.validate = function (i, dir, time, orig) {
            scrollToPos(time, i, true, dir, orig);
        };

        /**
        *
        */
        that.change = function (manual) {
            v = s.formatResult(that.temp);
            if (s.display == 'inline') {
                that.setValue(false, manual);
            } else {
                $('.dwv', dw).html(formatHeader(v));
            }

            if (manual) {
                event('onChange', [v]);
            }
        };

        /**
        * Changes the values of a wheel, and scrolls to the correct position
        */
        that.changeWheel = function (idx, time) {
            if (dw) {
                var i = 0,
                    j,
                    k,
                    nr = idx.length;

                for (j in s.wheels) {
                    for (k in s.wheels[j]) {
                        if ($.inArray(i, idx) > -1) {
                            warr[i] = s.wheels[j][k];
                            $('.dw-ul', dw).eq(i).html(generateWheelItems(i));
                            nr--;
                            if (!nr) {
                                position();
                                scrollToPos(time, undefined, true);
                                return;
                            }
                        }
                        i++;
                    }
                }
            }
        };

        /**
        * Return true if the scroller is currently visible.
        */
        that.isVisible = function () {
            return visible;
        };

        /**
        *
        */
        that.tap = function (el, handler) {
            var startX,
                startY;

            if (s.tap) {
                el.bind('touchstart', function (e) {
                    e.preventDefault();
                    startX = getCoord(e, 'X');
                    startY = getCoord(e, 'Y');
                }).bind('touchend', function (e) {
                    // If movement is less than 20px, fire the click event handler
                    if (Math.abs(getCoord(e, 'X') - startX) < 20 && Math.abs(getCoord(e, 'Y') - startY) < 20) {
                        handler.call(this, e);
                    }
                    tap = true;
                    setTimeout(function () {
                        tap = false;
                    }, 300);
                });
            }

            el.bind('click', function (e) {
                if (!tap) {
                    // If handler was not called on touchend, call it on click;
                    handler.call(this, e);
                }
            });

        };

        /**
        * Shows the scroller instance.
        * @param {Boolean} prevAnim - Prevent animation if true
        */
        that.show = function (prevAnim) {
            if (s.disabled || visible) {
                return false;
            }

            if (s.display == 'top') {
                anim = 'slidedown';
            }

            if (s.display == 'bottom') {
                anim = 'slideup';
            }

            // Parse value from input
            read();

            event('onBeforeShow', [dw]);

            // Create wheels
            var l = 0,
                i,
                label,
                mAnim = '';

            if (anim && !prevAnim) {
                mAnim = 'dw-' + anim + ' dw-in';
            }
            // Create wheels containers
            var html = '<div class="dw-trans ' + s.theme + ' dw-' + s.display + '">' + (s.display == 'inline' ? '<div class="dw dwbg dwi"><div class="dwwr">' : '<div class="dw-persp">' + '<div class="dwo"></div><div class="dw dwbg ' + mAnim + '"><div class="dw-arrw"><div class="dw-arrw-i"><div class="dw-arr"></div></div></div><div class="dwwr">' + (s.headerText ? '<div class="dwv"></div>' : ''));

            for (i = 0; i < s.wheels.length; i++) {
                html += '<div class="dwc' + (s.mode != 'scroller' ? ' dwpm' : ' dwsc') + (s.showLabel ? '' : ' dwhl') + '"><div class="dwwc dwrc"><table cellpadding="0" cellspacing="0"><tr>';
                // Create wheels
                for (label in s.wheels[i]) {
                    warr[l] = s.wheels[i][label];
                    html += '<td><div class="dwwl dwrc dwwl' + l + '">' + (s.mode != 'scroller' ? '<div class="dwwb dwwbp" style="height:' + hi + 'px;line-height:' + hi + 'px;"><span>+</span></div><div class="dwwb dwwbm" style="height:' + hi + 'px;line-height:' + hi + 'px;"><span>&ndash;</span></div>' : '') + '<div class="dwl">' + label + '</div><div class="dww" style="height:' + (s.rows * hi) + 'px;min-width:' + s.width + 'px;"><div class="dw-ul">';
                    // Create wheel values
                    html += generateWheelItems(l);
                    html += '</div><div class="dwwo"></div></div><div class="dwwol"></div></div></td>';
                    l++;
                }
                html += '</tr></table></div></div>';
            }
            html += (s.display != 'inline' ? '<div class="dwbc"><span class="dwbw dwb-c" style="width:30%;border-right: 1px solid #dbdbdb;"><span class="dwb">' +s.cancelText+ '</span></span>' + '<span class="dwbw dwb-n" style="width:35%;"><span class="dwb">' + s.clearText + '</span></span>'  + '<span class="dwbw dwb-s" style="width:30%;"><span class="dwb">' + s.setText + '</span></span></div></div>' : '<div class="dwcc"></div>') + '</div></div></div>';
            dw = $(html);

            scrollToPos();

            event('onMarkupReady', [dw]);

            // Show
            if (s.display != 'inline') {
                dw.appendTo('body');
                // Remove animation class
                setTimeout(function () {
                    dw.removeClass('dw-trans').find('.dw').removeClass(mAnim);
                }, 350);
            } else if (elm.is('div')) {
                elm.html(dw);
            } else {
                dw.insertAfter(elm);
            }

            event('onMarkupInserted', [dw]);

            visible = true;

            // Theme init
            theme.init(dw, that);

            if (s.display != 'inline') {
                // Init buttons
                that.tap($('.dwb-s span', dw), function () {
                    if (that.hide(false, 'set') !== false) {
                        that.setValue(false, true);
                        event('onSelect', [that.val]);
                        if(s.okCallback && typeof s.okCallback != "undefined") {
                            s.okCallback(s.formatResult(that.temp));//添加确定的回调函数（把值抽取出来,用于回调处理）
                        }
                    }
                });

                that.tap($('.dwb-c span', dw), function () {
                    if(s.cancelCallback && typeof s.cancelCallback != "undefined") {//添加取消的回调函数
                        s.cancelCallback();
                    }
                    that.cancel();
                });

                that.tap($('.dwb-n span', dw), function() {
                    if(s.clearCallback && typeof s.clearCallback != "undefined") {//添加清除的回调函数
                        s.clearCallback();
                        that.temp = [];
                    }
                    that.cancel();
                });

                // prevent scrolling if not specified otherwise
                if (s.scrollLock) {
                    dw.bind('touchmove', function (e) {
                        if (mh <= wh && mw <= ww) {
                            e.preventDefault();
                        }
                    });
                }

                // Disable inputs to prevent bleed through (Android bug)
                $('input,select,button').each(function () {
                    if (!$(this).prop('disabled')) {
                        $(this).addClass('dwtd').prop('disabled', true);
                    }
                });

                // Set position
                position();
                $(window).bind('resize.dw', function () {
                    // Sometimes scrollTop is not correctly set, so we wait a little
                    clearTimeout(debounce);
                    debounce = setTimeout(function () {
                        position(true);
                    }, 100);
                });
            }

            // Events
            dw.delegate('.dwwl', 'DOMMouseScroll mousewheel', function (e) {
                if (!isReadOnly(this)) {
                    e.preventDefault();
                    e = e.originalEvent;
                    var delta = e.wheelDelta ? (e.wheelDelta / 120) : (e.detail ? (-e.detail / 3) : 0),
                        t = $('.dw-ul', this),
                        p = +t.data('pos'),
                        val = Math.round(p - delta);
                    setGlobals(t);
                    calc(t, val, delta < 0 ? 1 : 2);
                }
            }).delegate('.dwb, .dwwb', START_EVENT, function (e) {
                // Active button
                $(this).addClass('dwb-a');
            }).delegate('.dwwb', START_EVENT, function (e) {
                e.stopPropagation();
                e.preventDefault();
                var w = $(this).closest('.dwwl');
                if (testTouch(e) && !isReadOnly(w) && !w.hasClass('dwa')) {
                    click = true;
                    // + Button
                    var t = w.find('.dw-ul'),
                        func = $(this).hasClass('dwwbp') ? plus : minus;

                    setGlobals(t);
                    clearInterval(timer);
                    timer = setInterval(function () { func(t); }, s.delay);
                    func(t);
                }
            }).delegate('.dwwl', START_EVENT, function (e) {
                // Prevent scroll
                e.preventDefault();
                // Scroll start
                if (testTouch(e) && !move && !isReadOnly(this) && !click) {
                    move = true;
                    $(document).bind(MOVE_EVENT, onMove);
                    target = $('.dw-ul', this);
                    scrollable = s.mode != 'clickpick';
                    pos = +target.data('pos');
                    setGlobals(target);
                    moved = iv[index] !== undefined; // Don't allow tap, if still moving
                    start = getCoord(e, 'Y');
                    startTime = new Date();
                    stop = start;
                    that.scroll(target, index, pos, 0.001);
                    if (scrollable) {
                        target.closest('.dwwl').addClass('dwa');
                    }
                }
            });

            event('onShow', [dw, v]);
        };

        /**
        * Hides the scroller instance.
        */
        that.hide = function (prevAnim, btn) {
            // If onClose handler returns false, prevent hide
            if (!visible || event('onClose', [v, btn]) === false) {
                return false;
            }

            // Re-enable temporary disabled fields
            $('.dwtd').prop('disabled', false).removeClass('dwtd');
            elm.blur();

            // Hide wheels and overlay
            if (dw) {
                if (s.display != 'inline' && anim && !prevAnim) {
                    dw.addClass('dw-trans').find('.dw').addClass('dw-' + anim + ' dw-out');
                    setTimeout(function () {
                        dw.remove();
                        dw = null;
                    }, 350);
                } else {
                    dw.remove();
                    dw = null;
                }
                visible = false;
                pixels = {};
                // Stop positioning on window resize
                $(window).unbind('.dw');
            }
        };

        /**
        * Cancel and hide the scroller instance.
        */
        that.cancel = function () {
            if (that.hide(false, 'cancel') !== false) {
                event('onCancel', [that.val]);
            }
        };

        /**
        * Scroller initialization.
        */
        that.init = function (ss) {
            // Get theme defaults
            theme = extend({ defaults: {}, init: empty }, ms.themes[ss.theme || s.theme]);

            // Get language defaults
            lang = ms.i18n[ss.lang || s.lang];

            extend(settings, ss); // Update original user settings
            extend(s, theme.defaults, lang, settings);

            that.settings = s;

            // Unbind all events (if re-init)
            elm.unbind('.dw');

            var preset = ms.presets[s.preset];

            if (preset) {
                pres = preset.call(e, that);
                extend(s, pres, settings); // Load preset settings
                extend(methods, pres.methods); // Extend core methods
            }

            // Set private members
            m = Math.floor(s.rows / 2);
            hi = s.height;
            anim = s.animate;

            if (elm.data('dwro') !== undefined) {
                e.readOnly = bool(elm.data('dwro'));
            }

            if (visible) {
                that.hide();
            }

            if (s.display == 'inline') {
                that.show();
            } else {
                read();
                if (input && s.showOnFocus) {
                    // Set element readonly, save original state
                    elm.data('dwro', e.readOnly);
                    e.readOnly = true;
                    // Init show datewheel
                    elm.bind('focus.dw', function () { that.show(); });
                }
            }
        };

        that.trigger = function (name, params) {
            return event(name, params);
        };

        that.values = null;
        that.val = null;
        that.temp = null;
        that._selectedValues = {}; // [];

        that.init(settings);
    }

    function testProps(props) {
        var i;
        for (i in props) {
            if (mod[props[i]] !== undefined) {
                return true;
            }
        }
        return false;
    }

    function testPrefix() {
        var prefixes = ['Webkit', 'Moz', 'O', 'ms'],
            p;

        for (p in prefixes) {
            if (testProps([prefixes[p] + 'Transform'])) {
                return '-' + prefixes[p].toLowerCase();
            }
        }
        return '';
    }

    function getInst(e) {
        return scrollers[e.id];
    }

    function getCoord(e, c) {
        var org = e.originalEvent,
            ct = e.changedTouches;
        return ct || (org && org.changedTouches) ? (org ? org.changedTouches[0]['page' + c] : ct[0]['page' + c]) : e['page' + c];

    }

    function bool(v) {
        return (v === true || v == 'true');
    }

    function constrain(val, min, max) {
        val = val > max ? max : val;
        val = val < min ? min : val;
        return val;
    }

    function calc(t, val, dir, anim, orig) {
        val = constrain(val, min, max);

        var cell = $('.dw-li', t).eq(val),
            o = orig === undefined ? val : orig,
            idx = index,
            time = anim ? (val == o ? 0.1 : Math.abs((val - o) * 0.1)) : 0;

        // Set selected scroller value
        inst.temp[idx] = cell.attr('data-val');

        inst.scroll(t, idx, val, time, orig);

        setTimeout(function () {
            // Validate
            inst.validate(idx, dir, time, orig);
        }, 10);
    }

    function init(that, method, args) {
        if (methods[method]) {
            return methods[method].apply(that, Array.prototype.slice.call(args, 1));
        }
        if (typeof method === 'object') {
            return methods.init.call(that, method);
        }
        return that;
    }

    var scrollers = {},
        timer,
        empty = function () { },
        h,
        min,
        max,
        inst, // Current instance
        date = new Date(),
        uuid = date.getTime(),
        move,
        click,
        target,
        index,
        start,
        stop,
        startTime,
        pos,
        moved,
        scrollable,
        mod = document.createElement('modernizr').style,
        has3d = testProps(['perspectiveProperty', 'WebkitPerspective', 'MozPerspective', 'OPerspective', 'msPerspective']),
        prefix = testPrefix(),
        extend = $.extend,
        tap,
        touch,
        START_EVENT = 'touchstart mousedown',
        MOVE_EVENT = 'touchmove mousemove',
        END_EVENT = 'touchend mouseup',
        onMove = function (e) {
            if (scrollable) {
                e.preventDefault();
                stop = getCoord(e, 'Y');
                inst.scroll(target, index, constrain(pos + (start - stop) / h, min - 1, max + 1));
            }
            moved = true;
        },
        defaults = {
            // Options
            width: 70,
            height: 40,
            rows: 3,
            delay: 300,
            disabled: false,
            readonly: false,
            showOnFocus: true,
            showLabel: true,
            wheels: [],
            theme: '',
            headerText: '{value}',
            display: 'modal',
            mode: 'scroller',
            preset: '',
            lang: 'en-US',
            setText: 'Set',
            cancelText: 'Cancel',
            clearText : 'Clear',//添加一个“不设置”的英文文字
            scrollLock: true,
            tap: true,
            okCallback : undefined,//添加一个确定的回调函数
            cancelCallback : undefined,//添加一个取消的回调函数
            clearCallback : undefined,//添加一个不设置按钮的回调
            formatResult: function (d) {
                return d.join(' ');
            },
            parseValue: function (value, inst) {
                var w = inst.settings.wheels,
                    val = value.split(' '),
                    ret = [],
                    j = 0,
                    i,
                    l,
                    v;

                for (i = 0; i < w.length; i++) {
                    for (l in w[i]) {
                        if (w[i][l][val[j]] !== undefined) {
                            ret.push(val[j]);
                        } else {
                            for (v in w[i][l]) { // Select first value from wheel
                                ret.push(v);
                                break;
                            }
                        }
                        j++;
                    }
                }
                return ret;
            }
        },

        methods = {
            init: function (options) {
                if (options === undefined) {
                    options = {};
                }

                return this.each(function () {
                    if (!this.id) {
                        uuid += 1;
                        this.id = 'scoller' + uuid;
                    }
                    scrollers[this.id] = new Scroller(this, options);
                });
            },
            enable: function () {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        inst.enable();
                    }
                });
            },
            disable: function () {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        inst.disable();
                    }
                });
            },
            isDisabled: function () {
                var inst = getInst(this[0]);
                if (inst) {
                    return inst.settings.disabled;
                }
            },
            isVisible: function () {
                var inst = getInst(this[0]);
                if (inst) {
                    return inst.isVisible();
                }
            },
            option: function (option, value) {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        var obj = {};
                        if (typeof option === 'object') {
                            obj = option;
                        } else {
                            obj[option] = value;
                        }
                        inst.init(obj);
                    }
                });
            },
            setValue: function (d, fill, time, temp) {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        inst.temp = d;
                        inst.setValue(true, fill, time, temp);
                    }
                });
            },
            getInst: function () {
                return getInst(this[0]);
            },
            getValue: function () {
                var inst = getInst(this[0]);
                if (inst) {
                    return inst.values;
                }
            },
            getValues: function () {
                var inst = getInst(this[0]);
                if (inst) {
                    return inst.getValues();
                }
            },
            show: function () {
                var inst = getInst(this[0]);
                if (inst) {
                    return inst.show();
                }
            },
            hide: function () {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        inst.hide();
                    }
                });
            },
            destroy: function () {
                return this.each(function () {
                    var inst = getInst(this);
                    if (inst) {
                        inst.hide();
                        $(this).unbind('.dw');
                        delete scrollers[this.id];
                        if ($(this).is('input')) {
                            this.readOnly = bool($(this).data('dwro'));
                        }
                    }
                });
            }
        };

    $(document).bind(END_EVENT, function (e) {
        if (move) {
            var time = new Date() - startTime,
                val = constrain(pos + (start - stop) / h, min - 1, max + 1),
                speed,
                dist,
                tindex,
                ttop = target.offset().top;

            if (time < 300) {
                speed = (stop - start) / time;
                dist = (speed * speed) / (2 * 0.0006);
                if (stop - start < 0) {
                    dist = -dist;
                }
            } else {
                dist = stop - start;
            }

            tindex = Math.round(pos - dist / h);

            if (!dist && !moved) { // this is a "tap"
                var idx = Math.floor((stop - ttop) / h),
                    li = $('.dw-li', target).eq(idx),
                    hl = scrollable;

                if (inst.trigger('onValueTap', [li]) !== false) {
                    tindex = idx;
                } else {
                    hl = true;
                }

                if (hl) {
                    li.addClass('dw-hl'); // Highlight
                    setTimeout(function () {
                        li.removeClass('dw-hl');
                    }, 200);
                }
            }

            if (scrollable) {
                calc(target, tindex, 0, true, Math.round(val));
            }

            move = false;
            target = null;

            $(document).unbind(MOVE_EVENT, onMove);
        }

        if (click) {
            clearInterval(timer);
            click = false;
        }

        $('.dwb-a').removeClass('dwb-a');

    }).bind('mouseover mouseup mousedown click', function (e) { // Prevent standard behaviour on body click
        if (tap) {
            e.stopPropagation();
            e.preventDefault();
            return false;
        }
    });

    $.fn.mobiscroll = function (method) {
        extend(this, $.mobiscroll.shorts);
        return init(this, method, arguments);
    };

    $.mobiscroll = $.mobiscroll || {
        /**
        * Set settings for all instances.
        * @param {Object} o - New default settings.
        */
        setDefaults: function (o) {
            extend(defaults, o);
        },
        presetShort: function (name) {
            this.shorts[name] = function (method) {
                return init(this, extend(method, { preset: name }), arguments);
            };
        },
        shorts: {},
        presets: {},
        themes: {},
        i18n: {}
    };

    $.scroller = $.scroller || $.mobiscroll;
    $.fn.scroller = $.fn.scroller || $.fn.mobiscroll;

})(jQuery);
/*jslint eqeq: true, plusplus: true, undef: true, sloppy: true, vars: true, forin: true */
/*=================================dataTime===========================================================*/
(function ($) {

    var ms = $.mobiscroll,
        date = new Date(),
        defaults = {
            dateFormat: 'mm/dd/yy',
            dateOrder: 'mmddy',
            timeWheels: 'hhiiA',
            timeFormat: 'hh:ii A',
            startYear: date.getFullYear() - 100,
            endYear: date.getFullYear() + 1,
            monthNames: ['January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December'],
            monthNamesShort: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'],
            dayNames: ['Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday'],
            dayNamesShort: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'],
            shortYearCutoff: '+10',
            monthText: 'Month',
            dayText: 'Day',
            yearText: 'Year',
            hourText: 'Hours',
            minuteText: 'Minutes',
            secText: 'Seconds',
            ampmText: '&nbsp;',
            nowText: 'Now',
            showNow: false,
            stepHour: 1,
            stepMinute: 1,
            stepSecond: 1,
            separator: ' '
        },
        preset = function (inst) {
            var that = $(this),
                html5def = {},
                format;
            // Force format for html5 date inputs (experimental)
            if (that.is('input')) {
                switch (that.attr('type')) {
                    case 'date':
                        format = 'yy-mm-dd';
                        break;
                    case 'datetime':
                        format = 'yy-mm-ddTHH:ii:ssZ';
                        break;
                    case 'datetime-local':
                        format = 'yy-mm-ddTHH:ii:ss';
                        break;
                    case 'month':
                        format = 'yy-mm';
                        html5def.dateOrder = 'mmyy';
                        break;
                    case 'time':
                        format = 'HH:ii:ss';
                        break;
                }
                // Check for min/max attributes
                var min = that.attr('min'),
                    max = that.attr('max');
                if (min) {
                    html5def.minDate = ms.parseDate(format, min);
                }
                if (max) {
                    html5def.maxDate = ms.parseDate(format, max);
                }
            }

            // Set year-month-day order
            var s = $.extend({}, defaults, html5def, inst.settings),
                offset = 0,
                wheels = [],
                ord = [],
                o = {},
                i,
                k,
                f = { y: 'getFullYear', m: 'getMonth', d: 'getDate', h: getHour, i: getMinute, s: getSecond, a: getAmPm },
                p = s.preset,
                dord = s.dateOrder,
                tord = s.timeWheels,
                regen = dord.match(/D/),
                ampm = tord.match(/a/i),
                hampm = tord.match(/h/),
                hformat = p == 'datetime' ? s.dateFormat + s.separator + s.timeFormat : p == 'time' ? s.timeFormat : s.dateFormat,
                defd = new Date(),
                stepH = s.stepHour,
                stepM = s.stepMinute,
                stepS = s.stepSecond,
                mind = s.minDate || new Date(s.startYear, 0, 1),
                maxd = s.maxDate || new Date(s.endYear, 11, 31, 23, 59, 59);

            inst.settings = s;

            format = format || hformat;

            if (p.match(/date/i)) {

                // Determine the order of year, month, day wheels
                $.each(['y', 'm', 'd'], function (j, v) {
                    i = dord.search(new RegExp(v, 'i'));
                    if (i > -1) {
                        ord.push({ o: i, v: v });
                    }
                });
                ord.sort(function (a, b) { return a.o > b.o ? 1 : -1; });
                $.each(ord, function (i, v) {
                    o[v.v] = i;
                });

                var w = {};
                for (k = 0; k < 3; k++) {
                    if (k == o.y) {
                        offset++;
                        w[s.yearText] = {};
                        var start = mind.getFullYear(),
                            end = maxd.getFullYear();
                        for (i = start; i <= end; i++) {
                            w[s.yearText][i] = dord.match(/yy/i) ? i : (i + '').substr(2, 2);
                        }
                    } else if (k == o.m) {
                        offset++;
                        w[s.monthText] = {};
                        for (i = 0; i < 12; i++) {
                            var str = dord.replace(/[dy]/gi, '').replace(/mm/, i < 9 ? '0' + (i + 1) : i + 1).replace(/m/, (i + 1));
                            w[s.monthText][i] = str.match(/MM/) ? str.replace(/MM/, '<span class="dw-mon">' + s.monthNames[i] + '</span>') : str.replace(/M/, '<span class="dw-mon">' + s.monthNamesShort[i] + '</span>');
                        }
                    } else if (k == o.d) {
                        offset++;
                        w[s.dayText] = {};
                        for (i = 1; i < 32; i++) {
                            w[s.dayText][i] = dord.match(/dd/i) && i < 10 ? '0' + i : i;
                        }
                    }
                }
                wheels.push(w);
            }

            if (p.match(/time/i)) {

                // Determine the order of hours, minutes, seconds wheels
                ord = [];
                $.each(['h', 'i', 's', 'a'], function (i, v) {
                    i = tord.search(new RegExp(v, 'i'));
                    if (i > -1) {
                        ord.push({ o: i, v: v });
                    }
                });
                ord.sort(function (a, b) {
                    return a.o > b.o ? 1 : -1;
                });
                $.each(ord, function (i, v) {
                    o[v.v] = offset + i;
                });

                w = {};
                for (k = offset; k < offset + 4; k++) {
                    if (k == o.h) {
                        offset++;
                        w[s.hourText] = {};
                        for (i = 0; i < (hampm ? 12 : 24); i += stepH) {
                            w[s.hourText][i] = hampm && i == 0 ? 12 : tord.match(/hh/i) && i < 10 ? '0' + i : i;
                        }
                    } else if (k == o.i) {
                        offset++;
                        w[s.minuteText] = {};
                        for (i = 0; i < 60; i += stepM) {
                            w[s.minuteText][i] = tord.match(/ii/) && i < 10 ? '0' + i : i;
                        }
                    } else if (k == o.s) {
                        offset++;
                        w[s.secText] = {};
                        for (i = 0; i < 60; i += stepS) {
                            w[s.secText][i] = tord.match(/ss/) && i < 10 ? '0' + i : i;
                        }
                    } else if (k == o.a) {
                        offset++;
                        var upper = tord.match(/A/);
                        w[s.ampmText] = { 0: upper ? 'AM' : 'am', 1: upper ? 'PM' : 'pm' };
                    }

                }

                wheels.push(w);
            }

            function get(d, i, def) {
                if (o[i] !== undefined) {
                    return +d[o[i]];
                }
                if (def !== undefined) {
                    return def;
                }
                return defd[f[i]] ? defd[f[i]]() : f[i](defd);
            }

            function step(v, st) {
                return Math.floor(v / st) * st;
            }

            function getHour(d) {
                var hour = d.getHours();
                hour = hampm && hour >= 12 ? hour - 12 : hour;
                return step(hour, stepH);
            }

            function getMinute(d) {
                return step(d.getMinutes(), stepM);
            }

            function getSecond(d) {
                return step(d.getSeconds(), stepS);
            }

            function getAmPm(d) {
                return ampm && d.getHours() > 11 ? 1 : 0;
            }

            function getDate(d) {
                var hour = get(d, 'h', 0);
                return new Date(get(d, 'y'), get(d, 'm'), get(d, 'd', 1), get(d, 'a') ? hour + 12 : hour, get(d, 'i', 0), get(d, 's', 0));
            }

            inst.setDate = function (d, fill, time, temp) {
                var i;
                // Set wheels
                for (i in o) {
                    this.temp[o[i]] = d[f[i]] ? d[f[i]]() : f[i](d);
                }
                this.setValue(true, fill, time, temp);
            };

            inst.getDate = function (d) {
                return getDate(d);
            };

            return {
                button3Text: s.showNow ? s.nowText : undefined,
                button3: s.showNow ? function () { inst.setDate(new Date(), false, 0.3, true); } : undefined,
                wheels: wheels,
                headerText: function (v) {
                    return ms.formatDate(hformat, getDate(inst.temp), s);
                },
                /**
                 * Builds a date object from the wheel selections and formats it to the given date/time format
                 * @param {Array} d - An array containing the selected wheel values
                 * @return {String} - The formatted date string
                 */
                formatResult: function (d) {
                    return ms.formatDate(format, getDate(d), s);
                },
                /**
                 * Builds a date object from the input value and returns an array to set wheel values
                 * @return {Array} - An array containing the wheel values to set
                 */
                parseValue: function (val) {
                    var d = new Date(),
                        i,
                        result = [];
                    try {
                        //修改点
                        if(val != "") {
                            if(s.preset == 'datetime') {
                                d = ms.parseDate('y-m-d h:i',val,s);
                            }
                            if(s.preset == 'date') {
                                d = ms.parseDate('y-m-d',val,s);
                            }
                        }else {
                            d = ms.parseDate(format, val, s);
                        }


                    } catch (e) {
                    }
                    // Set wheels
                    for (i in o) {
                        result[o[i]] = d[f[i]] ? d[f[i]]() : f[i](d);
                    }
                    return result;
                },
                /**
                 * Validates the selected date to be in the minDate / maxDate range and sets unselectable values to disabled
                 * @param {Object} dw - jQuery object containing the generated html
                 * @param {Integer} [i] - Index of the changed wheel, not set for initial validation
                 */
                validate: function (dw, i) {
                    var temp = inst.temp, //.slice(0),
                        mins = { y: mind.getFullYear(), m: 0, d: 1, h: 0, i: 0, s: 0, a: 0 },
                        maxs = { y: maxd.getFullYear(), m: 11, d: 31, h: step(hampm ? 11 : 23, stepH), i: step(59, stepM), s: step(59, stepS), a: 1 },
                        minprop = true,
                        maxprop = true;
                    $.each(['y', 'm', 'd', 'a', 'h', 'i', 's'], function (x, i) {
                        if (o[i] !== undefined) {
                            var min = mins[i],
                                max = maxs[i],
                                maxdays = 31,
                                val = get(temp, i),
                                t = $('.dw-ul', dw).eq(o[i]),
                                y,
                                m;
                            if (i == 'd') {
                                y = get(temp, 'y');
                                m = get(temp, 'm');
                                maxdays = 32 - new Date(y, m, 32).getDate();
                                max = maxdays;
                                if (regen) {
                                    $('.dw-li', t).each(function () {
                                        var that = $(this),
                                            d = that.data('val'),
                                            w = new Date(y, m, d).getDay(),
                                            str = dord.replace(/[my]/gi, '').replace(/dd/, d < 10 ? '0' + d : d).replace(/d/, d);
                                        $('.dw-i', that).html(str.match(/DD/) ? str.replace(/DD/, '<span class="dw-day">' + s.dayNames[w] + '</span>') : str.replace(/D/, '<span class="dw-day">' + s.dayNamesShort[w] + '</span>'));
                                    });
                                }
                            }
                            if (minprop && mind) {
                                min = mind[f[i]] ? mind[f[i]]() : f[i](mind);
                            }
                            if (maxprop && maxd) {
                                max = maxd[f[i]] ? maxd[f[i]]() : f[i](maxd);
                            }
                            if (i != 'y') {
                                var i1 = $('.dw-li', t).index($('.dw-li[data-val="' + min + '"]', t)),
                                    i2 = $('.dw-li', t).index($('.dw-li[data-val="' + max + '"]', t));
                                $('.dw-li', t).removeClass('dw-v').slice(i1, i2 + 1).addClass('dw-v');
                                if (i == 'd') { // Hide days not in month
                                    $('.dw-li', t).removeClass('dw-h').slice(maxdays).addClass('dw-h');
                                }
                            }
                            if (val < min) {
                                val = min;
                            }
                            if (val > max) {
                                val = max;
                            }
                            if (minprop) {
                                minprop = val == min;
                            }
                            if (maxprop) {
                                maxprop = val == max;
                            }
                            // Disable some days
                            if (s.invalid && i == 'd') {
                                var idx = [];
                                // Disable exact dates
                                if (s.invalid.dates) {
                                    $.each(s.invalid.dates, function (i, v) {
                                        if (v.getFullYear() == y && v.getMonth() == m) {
                                            idx.push(v.getDate() - 1);
                                        }
                                    });
                                }
                                // Disable days of week
                                if (s.invalid.daysOfWeek) {
                                    var first = new Date(y, m, 1).getDay(),
                                        j;
                                    $.each(s.invalid.daysOfWeek, function (i, v) {
                                        for (j = v - first; j < maxdays; j += 7) {
                                            if (j >= 0) {
                                                idx.push(j);
                                            }
                                        }
                                    });
                                }
                                // Disable days of month
                                if (s.invalid.daysOfMonth) {
                                    $.each(s.invalid.daysOfMonth, function (i, v) {
                                        v = (v + '').split('/');
                                        if (v[1]) {
                                            if (v[0] - 1 == m) {
                                                idx.push(v[1] - 1);
                                            }
                                        } else {
                                            idx.push(v[0] - 1);
                                        }
                                    });
                                }
                                $.each(idx, function (i, v) {
                                    $('.dw-li', t).eq(v).removeClass('dw-v');
                                });
                            }

                            // Set modified value
                            temp[o[i]] = val;
                        }
                    });
                },
                methods: {
                    /**
                     * Returns the currently selected date.
                     * @param {Boolean} temp - If true, return the currently shown date on the picker, otherwise the last selected one
                     * @return {Date}
                     */
                    getDate: function (temp) {
                        var inst = $(this).mobiscroll('getInst');
                        if (inst) {
                            return inst.getDate(temp ? inst.temp : inst.values);
                        }
                    },
                    /**
                     * Sets the selected date
                     * @param {Date} d - Date to select.
                     * @param {Boolean} [fill] - Also set the value of the associated input element. Default is true.
                     * @return {Object} - jQuery object to maintain chainability
                     */
                    setDate: function (d, fill, time, temp) {
                        if (fill == undefined) {
                            fill = false;
                        }
                        return this.each(function () {
                            var inst = $(this).mobiscroll('getInst');
                            if (inst) {
                                inst.setDate(d, fill, time, temp);
                            }
                        });
                    }
                }
            };
        };

    $.each(['date', 'time', 'datetime'], function (i, v) {
        ms.presets[v] = preset;
        ms.presetShort(v);
    });

    /**
     * Format a date into a string value with a specified format.
     * @param {String} format - Output format.
     * @param {Date} date - Date to format.
     * @param {Object} settings - Settings.
     * @return {String} - Returns the formatted date string.
     */
    ms.formatDate = function (format, date, settings) {
        if (!date) {
            return null;
        }
        var s = $.extend({}, defaults, settings),
            look = function (m) { // Check whether a format character is doubled
                var n = 0;
                while (i + 1 < format.length && format.charAt(i + 1) == m) {
                    n++;
                    i++;
                }
                return n;
            },
            f1 = function (m, val, len) { // Format a number, with leading zero if necessary
                var n = '' + val;
                if (look(m)) {
                    while (n.length < len) {
                        n = '0' + n;
                    }
                }
                return n;
            },
            f2 = function (m, val, s, l) { // Format a name, short or long as requested
                return (look(m) ? l[val] : s[val]);
            },
            i,
            output = '',
            literal = false;

        for (i = 0; i < format.length; i++) {
            if (literal) {
                if (format.charAt(i) == "'" && !look("'")) {
                    literal = false;
                } else {
                    output += format.charAt(i);
                }
            } else {
                switch (format.charAt(i)) {
                    case 'd':
                        output += f1('d', date.getDate(), 2);
                        break;
                    case 'D':
                        output += f2('D', date.getDay(), s.dayNamesShort, s.dayNames);
                        break;
                    case 'o':
                        output += f1('o', (date.getTime() - new Date(date.getFullYear(), 0, 0).getTime()) / 86400000, 3);
                        break;
                    case 'm':
                        output += f1('m', date.getMonth() + 1, 2);
                        break;
                    case 'M':
                        output += f2('M', date.getMonth(), s.monthNamesShort, s.monthNames);
                        break;
                    case 'y':
                        output += (look('y') ? date.getFullYear() : (date.getYear() % 100 < 10 ? '0' : '') + date.getYear() % 100);
                        break;
                    case 'h':
                        var h = date.getHours();
                        output += f1('h', (h > 12 ? (h - 12) : (h == 0 ? 12 : h)), 2);
                        break;
                    case 'H':
                        output += f1('H', date.getHours(), 2);
                        break;
                    case 'i':
                        output += f1('i', date.getMinutes(), 2);
                        break;
                    case 's':
                        output += f1('s', date.getSeconds(), 2);
                        break;
                    case 'a':
                        output += date.getHours() > 11 ? 'pm' : 'am';
                        break;
                    case 'A':
                        output += date.getHours() > 11 ? 'PM' : 'AM';
                        break;
                    case "'":
                        if (look("'")) {
                            output += "'";
                        } else {
                            literal = true;
                        }
                        break;
                    default:
                        output += format.charAt(i);
                }
            }
        }
        return output;
    };

    /**
     * Extract a date from a string value with a specified format.
     * @param {String} format - Input format.
     * @param {String} value - String to parse.
     * @param {Object} settings - Settings.
     * @return {Date} - Returns the extracted date.
     */
    ms.parseDate = function (format, value, settings) {
        var def = new Date();

        if (!format || !value) {
            return def;
        }

        value = (typeof value == 'object' ? value.toString() : value + '');

        var s = $.extend({}, defaults, settings),
            shortYearCutoff = s.shortYearCutoff,
            year = def.getFullYear(),
            month = def.getMonth() + 1,
            day = def.getDate(),
            doy = -1,
            hours = def.getHours(),
            minutes = def.getMinutes(),
            seconds = 0, //def.getSeconds(),
            ampm = -1,
            literal = false, // Check whether a format character is doubled
            lookAhead = function (match) {
                var matches = (iFormat + 1 < format.length && format.charAt(iFormat + 1) == match);
                if (matches) {
                    iFormat++;
                }
                return matches;
            },
            getNumber = function (match) { // Extract a number from the string value
                lookAhead(match);
                var size = (match == '@' ? 14 : (match == '!' ? 20 : (match == 'y' ? 4 : (match == 'o' ? 3 : 2)))),
                    digits = new RegExp('^\\d{1,' + size + '}'),
                    num = value.substr(iValue).match(digits);

                if (!num) {
                    return 0;
                }
                //throw 'Missing number at position ' + iValue;
                iValue += num[0].length;
                return parseInt(num[0], 10);
            },
            getName = function (match, s, l) { // Extract a name from the string value and convert to an index
                var names = (lookAhead(match) ? l : s),
                    i;

                for (i = 0; i < names.length; i++) {
                    if (value.substr(iValue, names[i].length).toLowerCase() == names[i].toLowerCase()) {
                        iValue += names[i].length;
                        return i + 1;
                    }
                }
                return 0;
                //throw 'Unknown name at position ' + iValue;
            },
            checkLiteral = function () {
                //if (value.charAt(iValue) != format.charAt(iFormat))
                //throw 'Unexpected literal at position ' + iValue;
                iValue++;
            },
            iValue = 0,
            iFormat;

        for (iFormat = 0; iFormat < format.length; iFormat++) {
            if (literal) {
                if (format.charAt(iFormat) == "'" && !lookAhead("'")) {
                    literal = false;
                } else {
                    checkLiteral();
                }
            } else {
                switch (format.charAt(iFormat)) {
                    case 'd':
                        day = getNumber('d');
                        break;
                    case 'D':
                        getName('D', s.dayNamesShort, s.dayNames);
                        break;
                    case 'o':
                        doy = getNumber('o');
                        break;
                    case 'm':
                        month = getNumber('m');
                        break;
                    case 'M':
                        month = getName('M', s.monthNamesShort, s.monthNames);
                        break;
                    case 'y':
                        year = getNumber('y');
                        break;
                    case 'H':
                        hours = getNumber('H');
                        break;
                    case 'h':
                        hours = getNumber('h');
                        break;
                    case 'i':
                        minutes = getNumber('i');
                        break;
                    case 's':
                        seconds = getNumber('s');
                        break;
                    case 'a':
                        ampm = getName('a', ['am', 'pm'], ['am', 'pm']) - 1;
                        break;
                    case 'A':
                        ampm = getName('A', ['am', 'pm'], ['am', 'pm']) - 1;
                        break;
                    case "'":
                        if (lookAhead("'")) {
                            checkLiteral();
                        } else {
                            literal = true;
                        }
                        break;
                    default:
                        checkLiteral();
                }
            }
        }
        if (year < 100) {
            year += new Date().getFullYear() - new Date().getFullYear() % 100 +
                (year <= (typeof shortYearCutoff != 'string' ? shortYearCutoff : new Date().getFullYear() % 100 + parseInt(shortYearCutoff, 10)) ? 0 : -100);
        }
        if (doy > -1) {
            month = 1;
            day = doy;
            do {
                var dim = 32 - new Date(year, month - 1, 32).getDate();
                if (day <= dim) {
                    break;
                }
                month++;
                day -= dim;
            } while (true);
        }
        hours = (ampm == -1) ? hours : ((ampm && hours < 12) ? (hours + 12) : (!ampm && hours == 12 ? 0 : hours));
        var date = new Date(year, month - 1, day, hours, minutes, seconds);
        if (date.getFullYear() != year || date.getMonth() + 1 != month || date.getDate() != day) {
            throw 'Invalid date';
        }
        return date;
    };

})(jQuery);


/*=========================================中文================================*/
(function ($) {
    $.mobiscroll.i18n.zh = $.extend($.mobiscroll.i18n.zh, {
        setText: '确定',
        cancelText: '取消',
        clearText : '不设置'
    });
})(jQuery);

(function ($) {
    $.mobiscroll.i18n.zh = $.extend($.mobiscroll.i18n.zh, {
        dateFormat: 'yyyy-mm-dd',
        dateOrder: 'yymmdd',
        dayNames: ['周日', '周一;', '周二;', '周三', '周四', '周五', '周六'],
        dayNamesShort: ['日', '一', '二', '三', '四', '五', '六'],
        dayText: '日',
        hourText: '时',
        minuteText: '分',
        monthNames: ['一月', '二月', '三月', '四月', '五月', '六月', '七月', '八月', '九月', '十月', '十一月', '十二月'],
        monthNamesShort: ['1月', '2月', '3月', '4月', '5月', '6月', '7月', '8月', '9月', '10月', '11月', '12月'],
        monthText: '月',
        secText: '秒',
        timeFormat: 'HH:ii',
        timeWheels: 'HHii',
        yearText: '年'
    });
})(jQuery);
//MCalendar.js e
//MLbs_map.js s
/**
 * Created by Administrator on 2015-4-29.
 */
var MLbs_map = (function() {
    var mapPositionObj = {}; //地图位置对象
    var checkOK = false;  //是否进行了定位
    var initData = null;  //控制地图未加载完就开始进行查询
    MLbsMapConstant = {
        C_iDistrictSelectType_province : 1,
        C_iDistrictSelectType_city : 2,

        C_sTplPath_provinceListTpl : "/cmp/plugins/lbs/tpl/cmp_mapProvinceList_tpl.html",
        C_sTplPath_cityListTpl : "/cmp/plugins/lbs/tpl/cmp_mapCityList_tpl.html"
    }
    function MLbs_map(el,options){
        var _this = this;
        _this.container = typeof el == 'object' ? el : document.getElementById(el);
        _this.options = $.extend(true,{
            basePath : null,
            title : "地图标注",
            lang : "zh_cn",
            height : 0,
            positionX : 0,
            positionY : 0,
            callback : null,
            fillBackData : null
        },options);
        _this.UiContainer = $('<div class="map_slideupWraper">' +
            '   <div class="map_UI">' +
            '       <div class="map_headerArea">' +
            '               <div class="map_controlArea">' +
            '                   <div class="map_headerTiTle">' +
            '                       <div class="map_title">'+_this.options.title+'</div>' +
            '                       <div class="map_btnClose">' +
            '                           <span class="map_uiClose"></span>' +
            '                       </div>' +
            '                   </div>' +
            '               <div class="map_headerRegion">' +
            '                   <div class="map_regionProvince">' +
            '                       <label class="province" id="provinceCtrl">四川省</label>' +
            '                       <span class="cmpPhone16 cmp_arrow_b_16"></span>' +
            '                   </div>' +
            '                   <div class="map_regionCity">' +
            '                       <label class="city" id="cityCtrl">广汉市</label>' +
            '                       <span class="cmpPhone16 cmp_arrow_b_16"></span>' +
            '                   </div>' +
            '               </div>' +
            '               <div class="map_headerCtrl">' +
            '                   <div class="map_headerSearch">' +
            '                       <div class="title">' +
            '                           <div class="box">' +
            '                               <div class="text"><input type="text" placeholder="我的位置" class="myPosition" id="mypos"></div>' +
            '                               <div class="delete_btn"><span class="icon cmpPhone32 cmp_search_close_32 clear"></span></div>' +
            '                           </div>' +
            '                           <div class="autoSearchTips" id="autoTip"></div>' +
            '                       </div>' +
            '                       <div class="position"><span class="cmpPhone48 cmp_map_position_48 pos"></span></div>' +
            '                       <div class="mark"><span class="cmpPhone48 cmp_cancel_map_position_48 del_mark"></span></div>' +
            '                   </div>' +
            '               </div>' +
            '           </div>' +
            '       </div>' +
            '       <div class="map_contentArea" >' +
            '           <div class="map_gaodeMap" id="map_gaodeMap"></div>' +
            '       </div>' +
            '       <div class="map_footerArea">' +
            '           <div class="map_footerOKBtn">确定</div>' +
            '       </div>' +
            '   </div>' +
            '</div>');
        _this.mapContainer = $("#map_gaodeMap", _this.UiContainer);
        _this.mapUi = $(".map_UI", _this.UiContainer);
        _this.headerCtrlArea = $(".map_headerCtrl", _this.UiContainer);
        _this.closeBtn = $(".map_btnClose", _this.UiContainer);
        _this.okBtn = $(".map_footerOKBtn", _this.UiContainer);
        _this.province = $(".province", _this.UiContainer);
        _this.city = $(".city", _this.UiContainer);
        _this.myPosition = $(".myPosition", _this.UiContainer);
        _this.autoSearchTips = $(".autoSearchTips", _this.UiContainer);
        _this.clearBtn = $(".delete_btn", _this.UiContainer);
        _this.positionBtn = $(".pos", _this.UiContainer);
        _this.delMarkBtn = $(".del_mark", _this.UiContainer);
        _this.mark = $(".mark", _this.UiContainer);
        var height = (_this.options.height != 0)? _this.options.height + "px" : $(window).height();
        var left = (_this.options.positionX != 0) ? _this.options.positionX + "px" : 0;
        var top = (_this.options.positionY != 0) ? _this.options.positionY + "px" : $(document).scrollTop();
        _this.UiContainer.css("height", height).css("top", top).css("left",left);

        var provincesArr = ['北京市', '天津市', '河北省', '山西省', '内蒙古自治区',
            '辽宁省', '吉林省', '黑龙江省', '上海市', '江苏省', '浙江省', '安徽省',
            '福建省', '江西省', '山东省', '河南省', '湖北省', '湖南省', '广东省',
            '广西壮族自治区', '海南省', '重庆市', '四川省', '贵州省', '云南省',
            '西藏自治区', '陕西省', '甘肃省', '青海省', '宁夏回族自治区', '新疆维吾尔自治区',
            '台灣', '香港特别行政区', '澳门特别行政区'];

        _this.provincesData = {
            data : provincesArr
        }
        _this.subDistrict = [];  //缓存省下面的市
        _this.subsubDistrict = [];//缓存市下面的区级
        _this.provinceList = null;
        _this.cityList = null;


        _this.map = null;//地图对象
        _this.toolbar = null;//ToolBar插件
        _this.mGeocoder = null;//地理逆编码插件
        _this.polygons = [];//查询到的区域的位置数据集合
        _this.mark = null; //地图上的标记对象
        _this.auto = null;
        _this.districtSearchService = null;

        _this.districtChooseContainerHtml = '<div class="map_listContainerLayer"><div class="map_listContainer">' +
            '   <span class="angle1"></span>' +
            '   <span class="angle2"></span>' +
            '   <div class="list">' +
            '       <div class="listContent" id="listContent"></div>' +
            '   </div>' +
            '</div></div>';
        _this.shieldLayer = $('<div class="map_shieldLayer"></div>');
        _this.initMapUI();
    }
    MLbs_map.prototype = {
        initMapUI : function() {
            var _this = this;
            var el = $("<div>");
            el.appendTo(_this.container);
            el.append(_this.UiContainer);
            var mapHeaderTitle = $(".map_headerTiTle",_this.UiContainer);
            var mapTitle = $(".map_title",mapHeaderTitle);
            var mapHeaderTitleWidth = mapHeaderTitle.width();
            var mapTitleWidth = mapTitle.width();
            mapTitle.css("left",(mapHeaderTitleWidth - mapTitleWidth)/2);
            var id = _this.mapContainer.attr("id");
            _this.bindWidgetCloseEvent();
            _this.map = new AMap.Map(id, {   //创建地图对象
                resizeEnable: true,
                lang: _this.options.lang
            });

            if (_this.options.fillBackData != "" && _this.options.fillBackData != null) {
                _this.reBindCreateMapUI(_this.options.fillBackData);
            } else {
                _this.initCreateMapUI();
            }
            _this.bindDistrictChoose();
            _this.initMyPosition();
            _this.startPosition();
            _this.clearMark();

            _this.bindOkBtnEvent();

        },
        initCreateMapUI : function() {
            var _this = this;
            var locationX = "";
            var locationY = "";
            //TODO  可以留个接口显示地图的加载进度条

            if(navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    //不使用html5的定位接口，定位不准改用高德的js定位
                    _this.initMapDisplay("","");
                },function(error){
                    if(typeof CWORKCom != "undefined"){//兼容性处理，app中利用高德android sdk定位
                        locationX = CWORKCom.getLon();
                        locationY = CWORKCom.getLat();
                        _this.initMapDisplay(locationX,locationY);
                    }else {
//                        _this.initMapDisplay("","");
                        switch(error.code) {
                            case error.TIMEOUT:
                                $.alert("定位超时，请重试");
                                break;
                            case error.POSITION_UNAVAILABLE:
                                $.alert('定位服务被拒绝');
                                break;
                            case error.PERMISSION_DENIED:
                                $.alert('请打开设备定位功能');
                                break;
                            case error.UNKNOWN_ERROR:
                                $.alert('未知错误');
                                break;
                        }
                    }
                },{
                    enableHighAcuracy: true,
                    timeout: 300,
                    maximumAge: 3000
                });
            }

        },
        initMapDisplay : function(locationX,locationY) {
            var _this = this;
            var locationInfo;
            var lnglatXY = "";
            _this.mark = new AMap.Marker({
                draggable: true,
                raiseOnDrag: true,
                zIndex : 500
            });

            if(locationX == "" && locationY == "") {
                //TODO  可以留个接口显示地图的加载进度条
                _this.map.plugin(["AMap.ToolBar"], function () {//定位
                    _this.toolBar = new AMap.ToolBar();
                    _this.map.addControl(_this.toolBar);
                    _this.toolBar.doLocation();
                    AMap.event.addListener(_this.toolBar, 'location', function callback(e, status) {
                        locationInfo = e.lnglat;
                        locationX = locationInfo.lng;
                        locationY = locationInfo.lat;
                        lnglatXY = new AMap.LngLat(locationX, locationY);
                        _this.map.setZoomAndCenter(16,lnglatXY);
                        _this.initGeocoder(lnglatXY);
                        _this.mark.setPosition(lnglatXY);
                    });

                });
            }else {
                lnglatXY = new AMap.LngLat(locationX, locationY);
                _this.map.setZoomAndCenter(16,lnglatXY);
                _this.initGeocoder(lnglatXY);
                _this.mark.setPosition(lnglatXY);
            }
            _this.mark.setMap(_this.map);
            _this.map.plugin(['AMap.Autocomplete'], function () {
                var autoOptions = {
                    city: ''
                }
                _this.auto = new AMap.Autocomplete(autoOptions);
            });

            AMap.service(["AMap.DistrictSearch"], function () {
                var options = {
                    subdistrict: 1,
                    extensions: "base"
                }
                _this.districtSearchService = new AMap.DistrictSearch(options);
            });

            _this.map.getCity(function (data) {
                if (data['province'] && typeof data['province'] === 'string') {
                    _this.province.text(data['province']);
                    _this.city.text(data['city']);
                    setTimeout(function() {
                        _this.bindDistrictSearch(data['province'], "province", null, true,false);
                    },20);


                }

            });

            _this.moveMarkEvent();

        },
        initGeocoder :function(lnglatXY) {
            var _this = this;
            var locationX = lnglatXY.getLng();
            var locationY = lnglatXY.getLat();
            _this.map.plugin(['AMap.Geocoder'], function () {//地理逆编码
                _this.mGeocoder = new AMap.Geocoder({
                    radius: 500,
                    extensions: "base"
                });
                AMap.event.addListener(_this.mGeocoder, "complete", function (data) {
                    initData = data;
                });
                _this.mGeocoder.getAddress(lnglatXY, function (status, result) {
                    if (status.toLocaleLowerCase() == "complete" && result.info.toLocaleLowerCase() == "ok") {
                        var addressComponent = result.regeocode.addressComponent;
                        var lbsProvince = addressComponent.province;
                        var lbsCity = addressComponent.city;
                        var cityCode = addressComponent.citycode;
                        var district = addressComponent.district;
                        var township = addressComponent.township;
                        var neighborhood = addressComponent.neighborhood;
                        var street = addressComponent.street;
                        var address = result.regeocode.formattedAddress;
                        checkOK = true;
                        mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",lbsProvince,lbsCity,district,street,address,cityCode,locationY,locationX,checkOK);
                        _this.myPosition.val(address);//获取当前街道位置
                    } else if (status.toLocaleLowerCase() == "complete" && result.info.toLocaleLowerCase() == "no_data") {
                        $.alert("初始化定位失败");
                    }

                });
            });
        },
        reBindCreateMapUI: function (fillBackData) {
            var _this = this;
            _this.myPosition.val(fillBackData.text);
            _this.map.plugin(["AMap.ToolBar"], function () {
                _this.toolBar = new AMap.ToolBar();
                _this.map.addControl(_this.toolBar);
                _this.map.plugin(["AMap.Geocoder"], function () {
                    _this.mGeocoder = new AMap.Geocoder({
                        radius: 500,
                        extensions: "base"
                    });
                    _this.mark = new AMap.Marker({
                        draggable: true,
                        raiseOnDrag: true,
                        zIndex : 500
                    });

                    if(fillBackData.lng != "" && fillBackData.lat != "") {
                        _this.mark.setPosition(new AMap.LngLat(fillBackData.lng,fillBackData.lat) );
                    }

                    _this.map.plugin(['AMap.Autocomplete'], function () {
                        var autoOptions = {
                            city: ''
                        }
                        _this.auto = new AMap.Autocomplete(autoOptions);
                    });
                    AMap.service(["AMap.DistrictSearch"], function () {
                        var options = {
                            subdistrict: 1,
                            extensions: "base"
                        }
                        _this.districtSearchService = new AMap.DistrictSearch(options);
                        _this.doPosition(false,true);
                    });
                    _this.mark.setMap(_this.map);
                    _this.moveMarkEvent();

                });

            });
        },
        /**
         * 绑定地区查询
         */
        bindDistrictChoose: function () {
            var _this = this;
            var provinceCtrl = _this.province;
            var cityCtrl = _this.city;
            provinceCtrl.off("click").on("click", function () {
                _this.provinceCityClickEvent(1,$(this));
            });
            cityCtrl.off("click").on("click", function () {
                _this.provinceCityClickEvent(2,$(this));
            });
        },
        provinceCityClickEvent : function(selectType,ctrl) {
            var _this = this;
            if(initData == null) return;
            if (($("#listprovinceCtrl").length > 0 && _this.provinceList != null) || ($("#listcityCtrl").length > 0 && _this.cityList != null)) {
                if ($("#provinceCtrl").next().hasClass("cmp_arrow_t_16")) {
                    $("#provinceCtrl").next().removeClass("cmp_arrow_t_16").addClass("cmp_arrow_b_16");
                }
                if ($("#cityCtrl").next().hasClass("cmp_arrow_t_16")) {
                    $("#cityCtrl").next().removeClass("cmp_arrow_t_16").addClass("cmp_arrow_b_16");
                }
                _this.listContainer.remove();
                _this.shieldLayer.remove();
                _this.provinceList = null;
                _this.cityList = null;
            }else {
                ctrl.next("span.cmpPhone16").removeClass("cmp_arrow_b_16").addClass("cmp_arrow_t_16");
                var id = _this.districtChooseShow(ctrl);
                if(MLbsMapConstant.C_iDistrictSelectType_province == selectType) {
                    _this.renderProvinceList(id);
                }else if(MLbsMapConstant.C_iDistrictSelectType_city == selectType) {
                    _this.renderCityList(id);
                }

            }
        },
        /**
         * 渲染省级列表
         * @param id
         */
        renderProvinceList: function (id) {
            var _this = this;
            _this.provinceList = new MList(id, {
                MListType: MList.MListType.dataShow,
                itemTplPath: _this.options.basePath + MLbsMapConstant.C_sTplPath_provinceListTpl
            });
            _this.provinceList.setDataForDefaultTplOrInitTpl(_this.provincesData);
            _this.bindProvinceChooseCallback(_this.provinceList);
        },
        /**
         * 绑定省级列表的点击回调
         * @param cmpList
         */
        bindProvinceChooseCallback: function (cmpList) {
            var _this = this;
            _this.listContainer.find(".map_listItemContainer").each(function () {
                $(this).off("click").on("click", function () {
                    var keyword = $(this).find(".name").text();
                    var level = $(this).find("input.level").val();
                    var provinceName = _this.province.text();
                    if (keyword != provinceName) {
                        _this.subDistrict = [];
                        _this.province.text(keyword);
                        _this.bindDistrictSearch(keyword, "province", null, false,false);
                    }
                    _this.province.next("span.cmpPhone16").removeClass("cmp_arrow_t_16").addClass("cmp_arrow_b_16");
                    _this.listContainer.remove();
                    _this.shieldLayer.remove();
                    cmpList = null;
                });
            });
        },
        /**
         * 渲染市级列表
         * @param id
         */
        renderCityList: function (id) {
            var _this = this;
            _this.cityList = new MList(id, {
                MListType: MList.MListType.dataShow,
                itemTplPath: _this.options.basePath + MLbsMapConstant.C_sTplPath_cityListTpl
            });
            var listData = {};
            var dataList = [];
            for (var i = 0, cc = _this.subDistrict[0].districtList.length; i < cc; i++) {
                var cityObj = {};
                cityObj.name = _this.subDistrict[0].districtList[i].name;
                cityObj.cityCode = _this.subDistrict[0].districtList[i].citycode;
                cityObj.level = _this.subDistrict[0].districtList[i].level;
                dataList.push(cityObj);
            }
            listData.data = dataList;
            _this.cityList.setDataForDefaultTplOrInitTpl(listData);
            _this.bindCityChooseCallback(_this.cityList);
        },
        /**
         * 绑定市级列表点击事件的回调
         * @param cmpList
         */
        bindCityChooseCallback: function (cmpList) {
            var _this = this;
            _this.listContainer.find(".map_listItemContainer").each(function () {
                $(this).off("click").on("click", function () {
                    var keyword = $(this).find(".name").text();
                    var level = $(this).find("input.level").val();
                    var oldCity = (_this.city.text() != "" && _this.city.text().length > 0) ? _this.city.text() : "";
                    _this.city.text(keyword);
                    _this.bindDistrictSearch(keyword, "city", oldCity, false,false);
                    _this.map.setCity(keyword);
                    _this.city.next("span.cmpPhone16").removeClass("cmp_arrow_t_16").addClass("cmp_arrow_b_16");
                    _this.listContainer.remove();
                    _this.shieldLayer.remove();
                    cmpList = null;
                });
            });
        },
        /**
         * 地区查询的UI体现
         * @param ctrl
         * @returns {*}
         */
        districtChooseShow: function (ctrl) {
            var _this = this;
            var winHeight = $(window).height();
            var mapContainerHeight = _this.mapContainer.height();
            var ctrlId = ctrl.attr("id");
            var angleLeft = ctrl.position().left + ctrl.width() / 2;
            _this.listContainer = $(_this.districtChooseContainerHtml);
            _this.listContainer.attr("id", "list" + ctrlId);
            var id = _this.listContainer.find(".listContent").attr("id");
            var angle1 = $(".angle1", _this.listContainer);
            var angle2 = $(".angle2", _this.listContainer);
            angle1.css("left", angleLeft);
            angle2.css("left", angleLeft);
            var top = _this.headerCtrlArea.position().top;
            _this.shieldLayer.css("height", winHeight).css("top", top);
            _this.shieldLayer.appendTo($("body"));
            _this.listContainer.css("top", top-1).css("height", mapContainerHeight);
            _this.listContainer.appendTo($("body"));

            return id;
        },
        /**
         * 绑定地区查询
         * @param keyword :查询关键字
         * @param level :查询级别
         * @param oldCity :原来的城市名称
         * @param isDefaultCity : 判断是否要显示默认的城市（此情况比如选择省份的时候，在没有选择任何城市的情况下，保证显示为查询的城市列表为第一个）
         * @param isBackfill:是否是回填值（此情况如果是回填值的话需要和isDefaultCity一起判断是否需要显示为默认第一城市名）
         */
        bindDistrictSearch: function (keyword, level, oldCity, isDefaultCity,isBackfill) {
            var _this = this;
            if (level != "province") {
                for (var i = 0, cc = _this.polygons.length; i < cc; i++) {  //清除覆盖物
                    _this.polygons[i].setMap(null);
                }
            }
            _this.districtSearchService.setLevel(level);
            _this.districtSearchService.search(keyword, function (status, e) {
                if (status == "complete") {
                    _this.handleSearchData(e, oldCity, isDefaultCity,isBackfill);
                }
            });

        },
        /**
         * 处理查询数据
         * @param e
         */
        handleSearchData: function (e, oldCity, isDefaultCity,isBackfill) {
            var _this = this;
            var lbsProvince = "";
            var lbsCity = "";
            var lbsAddr = "";
            var cityCode = "";
            var cityLng = "";
            var cityLat = "";
            var cityLngLat = null;
            var dList = e.districtList;
            for (var m = 0, ml = dList.length; m < ml; m++) {
                var data = dList[m].level;
                var bounds = dList[m].boundaries;
                if (data === "city" && dList[m].citycode) {
                    if (bounds) {
                        _this.polygons = [];
                        for (var i = 0; i < bounds.length; i++) {
                            var polygon = new AMap.Polygon({
                                map: _this.map,
                                strokeWeight: 0,
                                strokeColor: '#CC66CC',
                                fillColor: '#CCF3FF',
                                fillOpacity: 0,
                                path: bounds[i]
                            });
                            _this.polygons.push(polygon);
                        }
                    }
                }

                if (data == "province") {
                    var list = e.districtList || [];
                    var oldCityName = _this.city.text();
                    if (list.length >= 0) {
                        _this.subDistrict = list;

                        if (list[0].districtList[0].name != oldCityName) {
                            cityLng = list[0].districtList[0].center.lng;
                            cityLat = list[0].districtList[0].center.lat;
                            cityLngLat = new AMap.LngLat(cityLng, cityLat);

                            if(!isBackfill) {
                                if (!isDefaultCity) {
                                    mapPositionObj = {};  //清空
                                    checkOK = false;
                                    _this.myPosition.val(list[0].name);

                                    if (_this.mark != null) {
                                        _this.mark.setPosition(cityLngLat);
                                    }
                                    _this.city.text(list[0].districtList[0].name);
                                    _this.map.setCity(list[0].districtList[0].name);  //默认地图定位到列表第一个城市
                                    lbsProvince = list[0].name;
                                    cityCode = list[0].districtList[0].citycode;
                                    lbsCity = list[0].districtList[0].name;
                                    lbsAddr = list[0].name;
                                    checkOK = true;
                                    mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",lbsProvince,lbsCity,"","",lbsAddr,cityCode,cityLat,cityLng,checkOK);

                                }
                            }else {
                                if(!isDefaultCity) {
                                    var backfillProvinceName = _this.myPosition.val();
                                    if(backfillProvinceName == _this.province.text()) {
                                        _this.city.text(list[0].districtList[0].name);
                                    }
                                }
                            }

                        }
                    }
                } else if (data == "city") {
                    var list = e.districtList || [];

                    if (oldCity && oldCity != "" && oldCity.length > 0) {

                        if (!isDefaultCity) {
                            mapPositionObj = {};  //清空
                            checkOK = false;
                            if (list[0].name != oldCity) {
                                _this.myPosition.val(list[0].name);
                            }
                            cityLng = dList[0].center.lng;
                            cityLat = dList[0].center.lat;
                            cityLngLat = new AMap.LngLat(cityLng, cityLat);
                            if (_this.mark != null) {
                                _this.mark.setPosition(cityLngLat);
                            }
                            lbsProvince = list[0].name;
                            cityCode = list[0].districtList[0].citycode;
                            lbsCity = list[0].districtList[0].name;
                            lbsAddr = list[0].name;
                            checkOK = true;
                            mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",lbsProvince,lbsCity,"","",lbsAddr,cityCode,cityLat,cityLng,checkOK);

                        }

                    }


                    if (list.length >= 0) {
                        _this.subsubDistrict = [];
                        _this.subsubDistrict = list;
                    }
                }
            }
        },
        /**
         * 对myPosition输入域绑定各种事件
         */
        initMyPosition: function () {
            var _this = this;
            _this.clearBtn.off("click").on("click", function () {
                _this.myPosition.val("");
                if (_this.autoSearchTips.is(":visible")) {
                    _this.autoSearchTips.css("display", "none");
                }

            });
            _this.myPosition.off("focus").on("focus", function () {
                _this.myPosition.val("");
                if (_this.autoSearchTips.is(":visible")) {
                    _this.autoSearchTips.css("display", "none");
                }
            });
            _this.myPosition.off("keyup").on("keyup", function (event) {
                _this.bindAutoSearch();
            });

        },
        /**
         * 为定位按钮绑定定位事件
         */
        startPosition: function () {
            var _this = this;
            _this.positionBtn.off("click").on("click", function () {
                if (_this.autoSearchTips.is(":visible")) {
                    _this.autoSearchTips.css("display", "none");
                }
                _this.doPosition(true,false);
            });
        },
        /**
         * 做查询的动作
         * @param isDefaultCity：是否要默认显示城市列表为第一个的城市名
         * @param isBackfill：是否是回填值
         */
        doPosition: function (isDefaultCity,isBackfill) {
            var _this = this;
            var searchPositionVal = _this.myPosition.val();
            var provinceCityRegex = /(.*?)省(.*?)市|(.*?)自治区(.*?)市|(.*?)市(.*?)直辖市/;
            if (searchPositionVal == "" && searchPositionVal.length == 0) {
                return;  //没有输入不进行查询
            } else if (searchPositionVal != "" && searchPositionVal.length > 0) {
                if (_this.mGeocoder == null) {   //避免插件还未创建就开始进行位置搜索
                    $.alert("还未就位,请稍后重试");
                    return;
                } else {

                    if(provinceCityRegex.test(searchPositionVal)) {  //先查询到市可以大大提高效率
                        var provinceCity = searchPositionVal.match(provinceCityRegex)[0];
                        _this.mGeocoder.getLocation(provinceCity,function(status,result) {
                            var city = result.geocodes[0].addressComponent.city;
                            _this.map.setCity(city);
                        });
                    }

                    setTimeout(function(){
                        _this.mGeocoder.getLocation(searchPositionVal, function (status, result) {
                            if (status.toLowerCase() == "complete" && result.info.toLocaleLowerCase() == "ok") {
                                if (result.geocodes.length > 0) {
                                    var zoom = -1;
                                    var level = result.geocodes[0].level;
                                    var newLngLat = result.geocodes[0].location;
                                    var newLng = newLngLat.lng;
                                    var newLat = newLngLat.lat;
                                    var newMarkLngLat = new AMap.LngLat(newLng, newLat);
                                    var province = result.geocodes[0].addressComponent.province;
                                    var city = result.geocodes[0].addressComponent.city;
                                    var cityCode = result.geocodes[0].addressComponent.citycode;
                                    var district = result.geocodes[0].addressComponent.district;
                                    var street = result.geocodes[0].addressComponent.street;
                                    var address = result.geocodes[0].formattedAddress;
                                    if (city == "北京市") {
                                        city = "北京市市辖区";
                                    } else if (city == "上海市") {
                                        city = "上海市市辖区";
                                    } else if (city == "天津市") {
                                        city = "天津市市辖区";
                                    } else if (city == "重庆市") {
                                        city = "重庆市市辖区";
                                    }
                                    _this.province.text(province);
                                    _this.city.text(city);
                                    var newLocation = new AMap.LngLat(newLng, newLat);
                                    if (level == "省") {
                                        zoom = 8;
                                    } else if (level == "市") {
                                        zoom = 10;
                                    } else if (level == "区县") {
                                        zoom = 12;
                                    } else if (level == "村庄" || level == "乡镇") {
                                        zoom = 14;
                                    } else if (level == "道路" ) {
                                        zoom = 15;
                                    } else if (level == "公交站台、地铁站") {
                                        zoom = 16;
                                    } else if (level == "兴趣点" || level =="热点商圈") {
                                        zoom = 17;
                                    } else if(level == "门牌号") {
                                        zoom = 18;
                                    }
                                    _this.map.setZoomAndCenter(zoom, newLocation);
                                    _this.mark.setPosition(newMarkLngLat);
                                    checkOK = true;
                                    mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",province,city,district,street,address,cityCode,newLat,newLng,checkOK);

                                    _this.bindDistrictSearch(province, "province", null, isDefaultCity,isBackfill);  //这里只是做list的查询
                                    _this.bindDistrictChoose();

                                    initData = result;
                                }
                            } else if (status.toLocaleLowerCase() == "no_data") {
                                $.alert("未搜索到指定位置");
                            }
                        });
                    },300);

                }
            }

        },
        /**
         * 移动图钉
         */
        moveMarkEvent: function () {
            var _this = this;
            if (_this.mark != null) {
                AMap.event.addListener(_this.mark, "dragend", function (data) {
                    checkOK = false;
                    mapPositionObj = {};
                    var locationXY = data.lnglat;
                    var locationX = locationXY.lng;
                    var locationY = locationXY.lat;
                    var currentLngLat = new AMap.LngLat(locationX, locationY);
                    _this.mGeocoder.getAddress(currentLngLat, function (status, data) {
                        if (data.info.toLocaleLowerCase() == "ok" && status.toLocaleLowerCase() == "complete") {
                            var address = data.regeocode.formattedAddress;
                            var addressComponent = data.regeocode.addressComponent;
                            var province = addressComponent.province;
                            var cityCode = addressComponent.citycode;
                            var city = addressComponent.city;
                            var newLat = locationY;
                            var newLng = locationX;
                            var district = addressComponent.district;
                            var street = addressComponent.street;
                            checkOK = true;
                            mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",province,city,district,street,address,cityCode,newLat,newLng,checkOK);
                            _this.myPosition.val(address);
                        }

                    });
                });
            }
        },
        clearMark: function () {
            var _this = this;
            _this.delMarkBtn.off("click").on("click", function () {
                _this.map.clearMap();
                _this.myPosition.val("");
                mapPositionObj = null;
            });
        },
        /**
         * 添加搜索输入提示
         */
        bindAutoSearch: function () {
            var _this = this;
            var keyword = _this.myPosition.val();
            if (keyword.length > 0) {
                AMap.event.addListener(_this.auto, "complete", function (data) {
                    var resultStr = "";
                    var tipArr = data.tips;
                    if (tipArr && tipArr.length > 0) {
                        var myPosition = _this.myPosition.attr("id");
                        var autoSearchTips = _this.autoSearchTips.attr("id");
                        for (var i = 0; i < tipArr.length; i++) {
                            resultStr += "<div id='divid" + (i + 1) + "' onclick='handleMapSelectResult(" + i + "," + myPosition + "," + autoSearchTips + ")' ><span style=\"font-size: 12px;padding:5px 5px 5px 5px;\" class='name'>" + tipArr[i].name + "</span><span style='color:#C1C1C1;font-size: 12px' class='district'>" + tipArr[i].district + "</span></div>";
                        }
                    } else {
                        resultStr += "找不到结果!";
                    }
                    var top = _this.myPosition.position().top;
                    var myPosHeight = _this.myPosition.height();
                    _this.autoSearchTips.attr("curSelect", -1);
                    _this.autoSearchTips.attr("tipArr", tipArr);
                    _this.autoSearchTips.html(resultStr);
                    _this.autoSearchTips.css("display", "block").css("top", top + myPosHeight);
                });
                _this.auto.search(keyword);
            } else {
                _this.autoSearchTips.css("display", "none");
            }
        },
        bindWidgetCloseEvent : function() {
            var _this = this;
            _this.closeBtn.on("click", function () {
                _this.closeEvent();
            });
        },
        bindOkBtnEvent: function () {
            var _this = this;
            _this.okBtn.off("click").on("click", function () {
                if (!checkOK) {
                    $.alert("正在定位，定位信息不能为空 ");
                }else {
                    var callback = _this.options.callback;
                    if(callback) {
                        callback(mapPositionObj);
                    }
                }

            });
        },
        closeEvent : function() {
            var _this = this;
            _this.UiContainer.remove();
            _this.subDistrict = null;
            _this.subsubDistrict = null;//缓存市下面的区级
            _this.provinceList = null;
            _this.cityList = null;
            if(_this.map != null) {
                _this.map.destroy();
                _this.map = null;
            }
            if(_this.provinceList != null) {
                _this.provinceList = null;
            }
            if(_this.cityList != null) {
                _this.cityList = null;
            }
            if(_this.listContainer && _this.listContainer.length > 0) {
                _this.listContainer.remove();
            }
            if(_this.shieldLayer.length > 0) {
                _this.shieldLayer.remove();
            }
            _this.toolbar = null;//ToolBar插件
            _this.mGeocoder = null;//地理逆编码插件
            _this.polygons = null//查询到的区域的位置数据集合
            _this.mark = null; //地图上的标记对象
            _this.auto = null;
            _this.districtSearchService = null;
            mapPositionObj = null;
            checkOK = false;
            initData = null;
        }
    }
    var MMapPositionObj = function(id,isFirst,lbsContinent,lbsCountry,lbsProvince,lbsCity,lbsTown,lbsStreet,lbsAddr,cityCode,lbsLatitude,lbsLongitude,checkOk) {
        this.id = id;
        this.first = isFirst;
        this.lbsContinent = lbsContinent;
        this.lbsCountry = lbsCountry;
        this.lbsProvince = lbsProvince;
        this.lbsCity = lbsCity;
        this.lbsTown = lbsTown;
        this.lbsStreet = lbsStreet;
        this.lbsAddr = lbsAddr;
        this.cityCode = cityCode;
        this.lbsLatitude = lbsLatitude;
        this.lbsLongitude = lbsLongitude;
        this.checkOk = checkOk;
    }
    return MLbs_map;
})();
function handleMapSelectResult(index, myPosition, autoSearchTips) {

    var item = $("#divid" + (index + 1));
    var district = item.find("span.district").text();
    var name = item.find("span.name").text();
    var result = district + name;
    $(autoSearchTips).css("display", "none");
    $(autoSearchTips).text("");
    setTimeout(function(){
        $(myPosition).val(result);
    },50);
}
//MLbs_map.js e
//MLbs_location.js s
/**
 * Created by Administrator on 2015-4-29.
 */
var MLbs_location = (function() {
    var mapPositionObj = {}; //地图位置对象
    var checkOK = false;  //是否进行了定位
    function MLbs_location(el,options) {
        var _this = this;
        _this.container = typeof el == 'object' ? el : document.getElementById(el);
        _this.options = $.extend(true,{
            title : "位置定位",
            callback : null
        },options);
        _this.hiddenUI = $('<div class="map_slideupWraper map_uiHiddened">' +
            '   <div class="map_UI">' +
            '       <div class="map_headerArea_locate">' +
            '               <div class="map_controlArea">' +
            '                   <div class="map_headerTiTle">' +
            '                       <div class="map_title">'+_this.options.title+'</div>' +
            '                       <div class="map_btnClose">' +
            '                           <span class="map_uiClose"></span>' +
            '                       </div>' +
            '                   </div>' +
            '               </div>' +
            '       </div>' +
            '       <div class="map_contentArea_locate" >' +
            '           <div class="map_gaodeMap" id="map_gaodeMapLocate"></div>' +
            '       </div>' +
            '   </div>' +
            '</div>');
        _this.mapContainer = $(".map_gaodeMap", _this.hiddenUI);
        _this.closeBtn = $(".map_btnClose", _this.hiddenUI);
        _this.locateShieldLayer = $('<div class="cmp_loading_withShieldLayer">' +
            '   <div class="tipsBox">' +
            '       <div class="tipsContent"></div>'+
            '           <span class="cmpPhone48 cmp_loading_48"></span>'+
            '           <span class="text">正在定位<span class="cmp_location_aniDot">...</span></span>'+
            '   </div>'+
            '</div>') ;
        _this.init();
    }
    MLbs_location.prototype = {
        init: function () {
            var _this = this;
            var el = _this.el = $("<div>");
            el.appendTo(_this.container);
            _this.height = $(document).height();
            _this.top = $(document).scrollTop();
            _this.locateShieldLayer.css("height", _this.height).css("top", _this.top);
            _this.locateShieldLayer.appendTo(document.body);
            el.append(_this.hiddenUI);

            /*=================创建地图的各种对象和插件==============*/
            var id = _this.mapContainer.attr("id");
            _this.locateMap = new AMap.Map(id, {   //创建地图对象
                resizeEnable: true,
                lang: 'zh_cn'
            });

            var locationX = "";
            var locationY = "";
            if(navigator.geolocation) {
                navigator.geolocation.getCurrentPosition(function(position) {
                    //不使用html5的定位接口，定位不准改用高德的js定位
                    _this.initMapDisplay("","");
                },function(error){
                    if(typeof CWORKCom != "undefined"){//兼容性处理，app中利用高德android sdk定位
                        locationX = CWORKCom.getLon();
                        locationY = CWORKCom.getLat();
                        _this.initMapDisplay(locationX,locationY);
                    }else {
//                        _this.initMapDisplay("","");  //用于在pc上调试
                        switch(error.code) {
                            case error.TIMEOUT:
                                $.alert("定位超时，请重试");
                                break;
                            case error.POSITION_UNAVAILABLE:
                                $.alert('定位服务被拒绝');
                                break;
                            case error.PERMISSION_DENIED:
                                $.alert('请打开设备定位功能');
                                break;
                            case error.UNKNOWN_ERROR:
                                $.alert('未知错误');
                                break;
                        }
                        _this.locateShieldLayer.remove();
                    }
                },{
                    enableHighAcuracy: true,
                    timeout: 300,
                    maximumAge: 3000
                });

            }

        },
        initMapDisplay : function(locationX,locationY) {
            var _this = this;
            var lnglatXY;
            var toolBar = null;
            if(locationX == "" && locationY == "") {
                _this.locateMap.plugin(["AMap.ToolBar"], function () {
                    toolBar = new AMap.ToolBar();
                    _this.locateMap.addControl(toolBar);
                    toolBar.doLocation();
                    AMap.event.addListener(toolBar, "location", function callback(e, status) {
                        _this.locateMap.setFitView();
                        var locationInfo = e.lnglat;
                        locationX = locationInfo.lng;
                        locationY = locationInfo.lat;
                        lnglatXY = new AMap.LngLat(locationX, locationY);
                        _this.initGeocoder(lnglatXY);

                    });
                });
            }else {
                lnglatXY = new AMap.LngLat(locationX, locationY);
                _this.locateMap.setZoomAndCenter(16,lnglatXY);
                _this.initGeocoder(lnglatXY);
            }


        },
        initGeocoder :function(lnglatXY) {
            var _this = this;
            var locationX = lnglatXY.getLng();
            var locationY = lnglatXY.getLat();
            _this.locateMap.plugin(['AMap.Geocoder'], function () {//地理逆编码
                var mGeocoder = new AMap.Geocoder({
                    radius: 100,
                    extensions: "base"
                });

                mGeocoder.getAddress(lnglatXY, function (status, result) {
                    if (status.toLocaleLowerCase() == "complete" && result.info.toLocaleLowerCase() == "ok") {
                        var addressComponent = result.regeocode.addressComponent;
                        var lbsProvince = addressComponent.province;
                        var lbsCity = addressComponent.city;
                        var cityCode = addressComponent.citycode;
                        var district = addressComponent.district;
                        var township = addressComponent.township;
                        var neighborhood = addressComponent.neighborhood;
                        var street = addressComponent.street;
                        var address = result.regeocode.formattedAddress;
                        checkOK = true;
                        mapPositionObj = new MMapPositionObj(-1,false,"亚洲","中国",lbsProvince,lbsCity,district,street,address,cityCode,locationY,locationX,checkOK);

                        var concretePosition = ((typeof district == 'undefined') ? '' : district) +
                            ((typeof township == 'undefined') ? '' : township) +
                            ((typeof neighborhood == 'undefined') ? '' : neighborhood);
                        _this.locateShieldLayer.remove();
                        setTimeout(function () {
                            _this.hiddenUI.css("top", _this.top).css("height", _this.height).css("width", "100%");
                            var mapHeaderTitle = $(".map_headerTiTle",_this.hiddenUI);
                            var mapTitle = $(".map_title",mapHeaderTitle);
                            var mapHeaderTitleWidth = mapHeaderTitle.width();
                            var mapTitleWidth = mapTitle.width();
                            mapTitle.css("left",(mapHeaderTitleWidth - mapTitleWidth)/2);
                            var mark = new AMap.Marker({
                                position: lnglatXY,
                                draggable: false,
                                raiseOnDrag: true,
                                zIndex : 500
                            });
                            mark.setMap(_this.locateMap);
                            var infoWindowContent = '<div class="map_infoWindowContent">' +
                                '   <span class="angle1"></span>'+
                                '   <span class="angle2"></span>'+
                                '   <div class="addressContent">' +
                                '       <div style="color:#C1C1C1;font-size: 14px ">' + neighborhood + '</div>' +
                                '       <div style="font-size: 14px">地址：' + concretePosition + street + '</div>' +
                                '   </div>'+
                                '</div>';
                            var offsidePix = new AMap.Pixel(-10, -42);
                            var infoWindow = new AMap.InfoWindow({
                                isCustom : true,
                                position: lnglatXY,
                                content: infoWindowContent,
                                offset: offsidePix
                            });
                            infoWindow.setMap(_this.locateMap);
                            _this.bindCloseEvent(_this.locateMap,mGeocoder,mark);
                        }, 800);
                        var callback = _this.options.callback;
                        if(callback) {
                            callback(mapPositionObj);
                        }

                    } else if (status.toLocaleLowerCase() == "complete" && result.info.toLocaleLowerCase() == "no_data") {
                        $.alert("定位失败");
                    }

                });
            });
        },
        bindCloseEvent: function (map,mGeocoder,mark) {
            var _this = this;
            _this.closeBtn.off("click").on("click", function () {
                _this.hiddenUI.remove();
                if(map != null) {
                    map.clearMap();
                    mGeocoder = null;
                    mark = null;
                    map.destroy();
                    map = null;
                }
            });
        }
    }


    var MMapPositionObj = function(id,isFirst,lbsContinent,lbsCountry,lbsProvince,lbsCity,lbsTown,lbsStreet,lbsAddr,cityCode,lbsLatitude,lbsLongitude,checkOk) {
        this.id = id;
        this.first = isFirst;
        this.lbsContinent = lbsContinent;
        this.lbsCountry = lbsCountry;
        this.lbsProvince = lbsProvince;
        this.lbsCity = lbsCity;
        this.lbsTown = lbsTown;
        this.lbsStreet = lbsStreet;
        this.lbsAddr = lbsAddr;
        this.cityCode = cityCode;
        this.lbsLatitude = lbsLatitude;
        this.lbsLongitude = lbsLongitude;
        this.checkOk = checkOk;
    }
    return MLbs_location;
})();
//MLbs_location.js e
//imgLazyLoad.js s
/**
 *  @file 基于Jquery的图片延迟加载插件
 *  @name Imglazyload
 *  @desc 图片延迟加载
 */
(function ($) {
    /**
     * @name imglazyload
     * @grammar  imglazyload(opts) => self
     * @desc 图片延迟加载
     * **Options**
     * - ''placeHolder''     {String}:              (可选, 默认值:\'\')图片显示前的占位符
     * - ''container''       {Array|Selector}:      (可选, 默认值:window)图片延迟加载容器，若innerScroll为true，则传外层wrapper容器即可
     * - ''threshold''       {Array|Selector}:      (可选, 默认值:0)阀值，为正值则提前加载
     * - ''urlName''         {String}:              (可选, 默认值:data-url)图片url名称
     * - ''eventName''       {String}:              (可选, 默认值:scrollStop)绑定事件方式
     * - --''refresh''--     {Boolean}              --(可选, 默认值:false)是否是更新操作，若是页面追加图片，可以将该参数设为true--（该参数已经删除，无需使用该参数，可以同样为追加的图片增加延迟加载）
     * - ''innerScroll''     {Boolean}              (可选, 默认值:false)是否是内滚，若内滚，则不绑定eventName事件，用户需在外部绑定相应的事件，可调$.fn.imgLazyLoad.detect去检测图片是否出现在container中
     * - ''isVertical''      {Boolean}              (可选, 默认值:true)是否竖滚
     *
     * **events**
     * - ''startload'' 开始加载图片
     * - ''loadcomplete'' 加载完成
     * - ''error'' 加载失败
     *
     * 使用img标签作为初始标签时，placeHolder无效，可考虑在img上添加class来完成placeHolder效果，加载完成后移除。使用其他元素作为初始标签时，placeHolder将添加到标签内部，并在图片加载完成后替换。
     * 原始标签中以\"data-\"开头的属性会自动添加到加载后的图片中，故有自定义属性需要放在图片中的可以考虑以data-开头
     * @example $('.lazy-load').imglazyload();
     * $('.lazy-load').imglazyload().on('error', function (e) {
     *     e.preventDefault();      //该图片不再加载
     * });
     */
    $.fn.newOffset = function (coordinates) {
        if (coordinates) return this.each(function (index) {
            var $this = $(this),
                coords = funcArg(this, coordinates, index, $this.newOffset()),
                parentOffset = $this.offsetParent().newOffset(),
                props = {
                    top: coords.top - parentOffset.top,
                    left: coords.left - parentOffset.left
                };

            if ($this.css('position') == 'static') props['position'] = 'relative'
            $this.css(props)
        });
        if (this.length == 0) return null;
        var obj = this[0].getBoundingClientRect();
        return {
            left: obj.left + window.pageXOffset,
            top: obj.top + window.pageYOffset,
            width: Math.round(obj.width),
            height: Math.round(obj.height)
        }
    };

    var $isFunction = function isFunction(value) {
        return  Object.prototype.toString.call(value) == 'function'
    };
    var $isWindow = function isWindow(obj) {
        return obj != null && obj == obj.window
    };

    var pedding = [];
    $.fn.imgLazyLoad = function (opts) {
        var splice = Array.prototype.splice,
            opts = $.extend({
                threshold: 0,
                container: window,
                urlName: 'data-url',
                placeHolder: '',
                eventName: 'scrollStop',
                innerScroll: true,
                isVertical: true,
                loadComplete: null
            }, opts),
            $viewPort = $(opts.container),
            isVertical = opts.isVertical,
            isWindow = $isWindow($viewPort.get(0)),
            OFFSET = {
                win: [isVertical ? 'scrollY' : 'scrollX', isVertical ? 'innerHeight' : 'innerWidth'],
                img: [isVertical ? 'top' : 'left', isVertical ? 'height' : 'width']
            },
            $plsHolder = $(opts.placeHolder).length ? $(opts.placeHolder) : null,
            isImg = $(this).is('img');
        !isWindow && (OFFSET['win'] = OFFSET['img']);   //若container不是window，则OFFSET中取值同img
        function isInViewport(offset) {      //图片出现在可视区的条件
            var viewOffset = isWindow ? window : $viewPort.newOffset(),
                viewTop = viewOffset[OFFSET.win[0]],
                viewHeight = viewOffset[OFFSET.win[1]];
            return viewTop >= offset[OFFSET.img[0]] - opts.threshold - viewHeight && viewTop <= offset[OFFSET.img[0]] + offset[OFFSET.img[1]];
        }

        pedding = Array.prototype.slice.call($(pedding.reverse()).add(this), 0).reverse();    //更新pedding值，用于在页面追加图片
        if ($isFunction($.fn.imgLazyLoad.detect)) {    //若是增加图片，则处理placeHolder
            _addPlsHolder();
            return this;
        }

        function _load(div) {     //加载图片，并派生事件
            var $div = $(div),
                attrObj = {},
                $img = $div;
            if (!isImg) {
                $.each($div.get(0).attributes, function () {   //若不是img作为容器，则将属性名中含有data-的均增加到图片上
//                    alert((this.name.indexOf('data-')>-1) && '11');
//                    (this.name.indexOf('data-')>-1) && (attrObj[this.name] = this.value);
                    ~this.name.indexOf('data-') && (attrObj[this.name] = this.value);
                });
                $img = $('<img />').attr(attrObj);
            }
            $div.trigger('startload');
            $img.on('load', function () {
                !isImg && $div.replaceWith($img);     //若不是img，则将原来的容器替换，若是img，则直接将src替换
                if(opts.loadComplete){
                    opts.loadComplete()
                }
//                ~opts.loadComplete && ;//绑定加载完成事件
                $img.off('load');
            }).on('error', function () {     //图片加载失败处理
                var errorEvent = $.Event('error');       //派生错误处理的事件
                $div.trigger(errorEvent);
                errorEvent.defaultPrevented || pedding.push(div);
                $img.off('error').remove();
            }).attr('src', $div.attr(opts.urlName));


//            if($img.complete){
//                if (opts.loadComplete) {
//                    opts.loadComplete();
//                }
//            }
        }

        function _detect() {     //检测图片是否出现在可视区，并对满足条件的开始加载
            var i, $image, offset, div;
            for (i = pedding.length; i--;) {
                $image = $(div = pedding[i]);
                //判断图片是否隐藏
                if ($image.is(":hidden")) {
                    continue;
                }
                //if(nativeWebBridge.services.connectionServices.checkConnection() == MConnectionServices.C_iConnectionState_Cell3G){
                //    $image.attr("index",i);
                //    $image.off("click").on("click",function(){
                //       var _offset = $(this).newOffset();
                //        isInViewport(_offset) && (splice.call(pedding, parseInt($(this).attr("index")), 1), _load($(this)));
                //    });
                //}else{
                    offset = $image.newOffset();
                    isInViewport(offset) && (splice.call(pedding, i, 1), _load(div));
                //}
            }
        }

        function _addPlsHolder() {
            !isImg && $plsHolder && $(pedding).append($plsHolder);   //若是不是img，则直接append
        }

        $(document).ready(function () {    //页面加载时条件检测
            _addPlsHolder();     //初化时将placeHolder存入
            _detect();
        });

        !opts.innerScroll && $(window).on(opts.eventName + ' ortchange', function () {    //不是内滚时，在window上绑定事件
            _detect();
        });
        $.fn.imgLazyLoad.detect = _detect;    //暴露检测方法，供外部调用
        return this;
    };
})(jQuery);
//imgLazyLoad.js e
//MContainer_list.js s
/**
 * Created by Administrator on 2014-12-29.
 */
var MContainer_list = (function() {
    /**
     * list三大结构
     * @type {{pullDownWidgetHtml: string, clickDownWidgetHtml: string, listDataAreaHtml: string}}
     * @pullDownWidgetHtml : 下拉的html
     * @clickDownWidgetHtml : 点击加载的html
     * @listDataAreaHtml : 装list数据的容器区域
     */
    var MListWidgetHtml = {
        pullDownWidgetHtml : '<div class="pullDown">' +
            '<span class="pullDownIcon"></span>' +
            '<div class="pullDownText">' +
            '<p id="cmp_textForPullDown">{textForPullDown}</p>' +
            '<p id="cmp_textForPullDownListNumSum">{textForPullDownListNumSum}</p>' +
            '<p id="cmp_textForPullDownListTime">{textForPullDownListTime}</p>' +
            '</div>' +
            '</div>',
        clickDownWidgetHtml :  '<div class="clickDown loading">' +
            '<p style="margin-top: 15px;"  id="cmp_textForClickDownLoadMore">{textForClickDownLoadMore}</p>' +
            '<p style="margin-top: 5px;"  id="cmp_textForClickDownListNum">{textForClickDownListNum}</p>' +
            '<span class="pullDownIcon"></span>' +
            '</div>',
        listDataAreaHtml : '<div class="list_data"></div>'
    }

    /**
     * 下拉动画最大界限
     * @type {{MaxRefreshScrollDistance: number}}
     * @MaxRefreshScrollDistance ：滑动最大位置，当超过此值，容器将进行加载数据的事件和刷新
     */
    var MListScrollAnimation = {
        MaxRefreshScrollDistance : 5
    }
    var MListContainerType = {
        updown : 1,   //有上拉下拉按钮
        noUpdown : 2  //无上拉下拉按钮
    }
    /**
     * List数据对象
     * @param options ：数据配置项
     * @isTemplate : 是否启用模板类list（tips：其与listContent是互斥的，启用了模板就不会使用listContent）
     * @listItemTemplatePath : 模板地址（tips：当开发者启用模板类时，该地址一定要定义）
     * @listData : list数据（tips：当开发者启用模板类时，该数据一定要定义）
     * @listContent : 当没有启用模板时，调用该list数据（tips：该数据自由度高，开发者可根据自身需要，任意定义）
     * @constructor
     */

    MListData = function(options) {
        this.isTemplate = true;
        this.listItemTemplatePath = null;
        this.listData = null;
        this.listContent = null;
        $.extend(this,options);
    }

    /**
     * list容器配置参数
     * @param options ：配置参数
     * @id : 容器id
     * @hScroll : 是否启动横向滚动
     * @vScroll : 是否启动纵向滚动
     * @position : 滚动区域的位置参数，其中position必须为absolute
     * @MaxRefreshScrollDistance : 开始刷新的动画的最大滑动距离
     * @pullDownLoadMoreDataCallback : 下拉刷新回调函数
     * @clickDownLoadMoreDataCallback ： 点击加载回调函数
     * @refreshWidgetText ：动画显示时的文字显示
     * @imageLazyLoad ：是否启用图片懒加载
     * @constructor
     */
    MListContainerParam = function(options) {
        this.id = null;
        this.listType = 1;
        this.hScroll = false;
        this.vScroll = true;
        this.position = {
            position : 'absolute',
            top : '0px',
            bottom : '0px',
            left : '0px',
            right : '0px',
            width : '100%'
        }
        this.MaxRefreshScrollDistance = MListScrollAnimation.MaxRefreshScrollDistance;
        this.pullDownLoadMoreDataCallback = null;
        this.clickDownLoadMoreDataCallback = null;
		this.scrollerRefreshCallback = null;
        this.refreshWidgetText = {
            textForPullDown: '下拉刷新',//下拉刷新
            textForPullDownRelease: '松手开始更新',//松手开始更新
            textForPullDownListNumSum: '共{datasCount}条',//共有多少数据
            textForPullDownListTime: '最近更新：{currentRefreshTime}',//最近更新时间
            textForClickDownLoadMore: '加载更多',//加载更多
            textForClickDownListNum: '还有{datasLeaveNumber}条',//还剩下多少条
            textForLoading: '加载中'//加载中
        }
        this.imageLazyLoad = {
            enable : true,
            cmpClassName : 'cmp-imglazyload',
            urlAttrName : "data-url"
        }
        $.extend(true,this,options);
    }

    /**
     * list容器
     * @constructor
     */
    function  MContainer_list() {
        var _this = this;
        _this.myScroll = null;
        _this.containerId = null;
        _this.refreshWidgetText = null;
        _this.imageLazyLoad = null;
        _this.container = null;
    }

    MContainer_list.prototype = {
        /**
         * 创建滚动容器（对外接口）
         * @param options
         * @returns {MContainerForList}
         */
        createScrollContainer : function(options) {
            var _this = this;
            var container = null;
            var scrollArea = null;
            var myScroll = null;
            var id = options.id;
            if(id[0] != "#") {
                _this.containerId = id;
                container = $("#" + id);
            }else {
                _this.containerId = id = id.substring(1,id.length);
                container = $(id);
            }

            container.css('position',options.position.position)
                .css('top',options.position.top)
                .css('bottom',options.position.bottom)
                .css('left',options.position.left)
                .css('right',options.position.right)
                .css('width',options.position.width);
            container.html($('<div class="scroller" id="'+id+'_scroller"></div>'));
            scrollArea = $(container.find('#'+id+'_scroller')[0]);
            _this.imageLazyLoad = options.imageLazyLoad;
            if(options.listType == MListContainerType.updown) {
                _this.refreshWidgetText = options.refreshWidgetText;
                scrollArea.append(MListWidgetHtml.pullDownWidgetHtml)
                    .append(MListWidgetHtml.listDataAreaHtml)
                    .append(MListWidgetHtml.clickDownWidgetHtml);
                var pullDownEl = scrollArea.find('.pullDown')[0];
                var pullDownE2 = scrollArea.find('.pullDown');
                var pullDownOffset = pullDownEl.offsetHeight;
                var pullUpE2 = scrollArea.find('.clickDown');
                myScroll = new iScroll(id,{
                    scrollbarClass: 'myScrollbar',
                    useTransition: false,
                    fixedScrollbar: false,
                    hScroll : options.hScroll,
                    vScroll : options.vScroll,
                    topOffset : pullDownOffset,
                    hideScrollbar : true,
                    onRefresh : function() {
                        if (pullDownE2.hasClass('loading')) {
                            pullDownE2.removeClass('loading');
                            pullDownE2.find("p").show();
                            $(pullDownE2.find("p")).first()
                                .removeClass("change_text_height")
                                .text(options.refreshWidgetText.textForPullDown);
                        }
                        else if (pullUpE2.hasClass('loading')) {
                            pullUpE2.find("p").show();
                            pullUpE2.find("span").hide();
                            $(pullUpE2.find("p")).first()
                                .removeClass("margin_t_25")
                                .addClass("margin_t_15")
                                .text(options.refreshWidgetText.textForClickDownLoadMore);
                        }
						if(options.scrollerRefreshCallback != null) {
                            if(typeof options.scrollerRefreshCallback != "function") {
                                throw "this param must be function";
                            }else {
                                options.scrollerRefreshCallback(this);
                            }
                        }
                    },
                    onScrollMove: function () {
                        if (this.y > MListScrollAnimation.MaxRefreshScrollDistance && !pullDownE2.hasClass('flip')) {
                            pullDownE2.addClass('flip');
                            $(pullDownE2.find("p")).first().text(options.refreshWidgetText.textForPullDownRelease);
                            this.minScrollY = 0;
                        } else if (this.y < MListScrollAnimation.MaxRefreshScrollDistance && pullDownE2.hasClass('flip')) {
                            pullDownE2.removeClass('flip');
                            $(pullDownE2.find("p")).first().text(options.refreshWidgetText.textForPullDown);
                            this.minScrollY = -pullDownOffset;
                        }
                    },
                    onScrollEnd: function () {
                        if (container.height() <= (container.find(".list_data").height() + pullDownOffset)) {
                            pullUpE2.css("opacity", "1");
                            pullUpE2.unbind("click").bind("click", function () {
                                pullUpE2.find("p").hide();
                                pullUpE2.find("span").show();
                                $(pullUpE2.find("p")).first().removeClass("margin_t_15").addClass("margin_t_25").text(options.refreshWidgetText.textForLoading).show();
                                if(options.clickDownLoadMoreDataCallback != null) {
                                    if(typeof options.clickDownLoadMoreDataCallback != "function") {
                                        throw "this param must be function";
                                    }else {
                                        options.clickDownLoadMoreDataCallback(this);
                                    }
                                }else {
                                    _this.myScroll.refresh();
                                }
                            });
                        }
                        if (pullDownE2.hasClass('flip')) {
                            pullDownE2.removeClass('flip').addClass('loading');
                            pullDownE2.find("p").hide();
                            $(pullDownE2.find("p")).first().addClass("change_text_height").text(options.refreshWidgetText.textForLoading).show();
                            if(options.pullDownLoadMoreDataCallback != null) {
                                if(typeof options.pullDownLoadMoreDataCallback != "function") {
                                    throw "this param must be function";
                                }else {
                                    options.pullDownLoadMoreDataCallback(this);
                                }
                            }else {
                                _this.myScroll.refresh();
                            }



                        }
                        if (options.imageLazyLoad.enable) {
                            $.fn.imgLazyLoad.detect();
                        }
                    }
                });
            }else if(options.listType == MListContainerType.noUpdown) {
                scrollArea.append(MListWidgetHtml.listDataAreaHtml);
                myScroll = new iScroll(id,{
                    scrollbarClass: 'myScrollbar',
                    hScroll: options.hScroll,
                    vScroll: options.vScroll,
                    hideScrollbar: true,
                    fadeScrollbars: true,
                    hScrollbar:false,
                    bounce: true,
                    onScrollEnd: function () {
                        if (options.imageLazyLoad.enable) {
                            $.fn.imgLazyLoad.detect();
                        }
                    }
                });
            }

            _this.myScroll = myScroll;
            _this._initImgLazyLoad(options.imageLazyLoad);
            _this.container = container;
            return _this;
        },
        /**
         * 渲染list数据（对外接口）
         * @param options，其中1、isTemplate：是否是使用模板形式渲染列表true：必须有模板地址；false：可以是不同html
         *                    2、listItemTemplatePath：模板地址（当isTemplate为true，该模板地址是必须的）
         *                    3、listData：列表数据（当isTemplate为true，该数据是必须的）
         *                          其中:1、data必须的属性（用于渲染的数据）
         *                              2、datasCount必须的属性（用于数据总数的渲染）
         *                              3、datasLeaveNumber必须的属性（用于数据剩余数的渲染）
         *                              4、container可设置属性（建议设置，用于在tab容器中该list的唯一性）
         *                              5、其他，根据模板需要自行进行设置
         *                    4、listContent：列表内容：与isTemplate互斥
         */
        renderListData : function(options) {
            var _this = this;
            var listTemplateHtmlStr = null;
            var listTemplateHtml = null;
            var listDataArea = $("#"+_this.containerId).find(".list_data");
            if(options.isTemplate) {
                if(options.listItemTemplatePath == null || typeof options.listItemTemplatePath == undefined) {
                    throw "if you use template way to render data,you must define template path and template data";
                }
                listTemplateHtmlStr = _this._getTemplateHtml(options.listItemTemplatePath);
                listTemplateHtml = MUtils.tpl(listTemplateHtmlStr,options.listData);
                listDataArea.html(listDataArea.html() + listTemplateHtml);

            }else{  //目前考虑卡片可能就要这个
                if(options.listContent.length == 0 || options.listContent == null || typeof options.listContent == undefined) {
                    throw "you must define list content";
                }
                listDataArea.html(listDataArea.html() + options.listContent);
            }
            _this.myScroll.refresh();
            _this._setRefreshDomShow(options);
            _this._initImgLazyLoad(_this.imageLazyLoad);

        },
        /**
         * 根据模板地址获取模板的html(tips:私有方法)
         * @param tplPath
         * @returns {string}
         * @private
         */
        _getTemplateHtml : function(tplPath) {
            if(!tplPath) {
                throw "the template path must not be null or undefined";
            }
            var templateHtmlStr = MUtils.readFileContent(tplPath);
            return templateHtmlStr;
        },
        /**
         * 文字动画显示（tips：私有方法）
         * @param options
         * @private
         */
        _setRefreshDomShow: function (options) {
            var _this = this;
            //建议把容器定义，避免在tab容器里的，该list有缓存的情况下出现混乱
            var container = options.listData.container == undefined ? null : options.listData.container;
            var defaultRefreshShowData = {
                datasCount: 0,
                currentRefreshTime: new Date().format("yyyy-MM-dd hh:mm:ss"),
                datasLeaveNumber: 0
            };
            $.extend(defaultRefreshShowData, options.listData);

            for (var j in _this.refreshWidgetText) {
                var $cmpJ = container == null ? $("#cmp_" + j) : container.find("#cmp_" + j);
                $cmpJ.html(_this.refreshWidgetText[j]);

                for (var k in defaultRefreshShowData) {
                    if (_this.refreshWidgetText[j].indexOf('{' + k + '}') < 0) {
                        continue;
                    }
                    $cmpJ.html(_this.refreshWidgetText[j].replace("{" + k + "}"
                        , defaultRefreshShowData[k]));
                }
            }
        },
        /**
         * 图片懒加载初始化
         */
        _initImgLazyLoad: function (imageLazyLoadOptions) {
            if (imageLazyLoadOptions.enable) {
                $('.' + imageLazyLoadOptions.cmpClassName).on('startload', function () {
                    $(this).removeClass('preload');
                }).imgLazyLoad({
                    urlName: imageLazyLoadOptions.urlAttrName
                });
            }
        }
    }
    return MContainer_list;
})();
//MContainer_list.js e
//MContainer_tab.js s
var MContainer_tab = (function() {

    function MContainer_tab(){}

    /**
     * tab容器参数
     * @param options
     * @tabsContainerID : tab容器的id
     * @tabs ：tabs数组（数组大小至少大于1）
     * @constructor
     */
    MTabsContainerParam = function(options) {
        this.tabsContainerID = null;
        this.tabs = [{
            tabID : null,                 //该tabs的id
            tabName : null,              //tab名字
            containerObj : null,        //该tab的所拥有的容器对象
            renderContainerCallback : null,    //渲染tab的回调函数
            containerSwitchCallback : null//tabs渲染后的切换事件回调函数
        }]
        $.extend(this,options);
    }
    MContainer_tab.prototype = {

        //创建tabs容器(对外接口)
        createTabsContainer : function(options) {
            var _this = this;
            var id = options.tabsContainerID;
            var tabsContainer = null;
            if(options.tabs.length <= 1) {
                throw "the tabs number must be more than 2";
            }
            if(id[0] != "#") {
                tabsContainer = $("#" + id);
            }else {
                tabsContainer = $(id);
            }
            var tabsTemplatePath = MUtils.getFilePathByJSName("MContainer_tab.js") + "tpl/cmp_tab_tpl.html";
            var tabsTemplateHtml = _this._getTemplateHtml(options,tabsTemplatePath);
            tabsContainer.html(tabsTemplateHtml);
            tabsContainer.trigger('create');
            var $content_nav_bar = $("#content_nav_bar");

            var $tabs = $content_nav_bar.find("a");
            var tabsContentHeight = $("body").height() - $("header").height() - $("footer").height();
            var wrapper_h = tabsContentHeight - $content_nav_bar.height() - 1;
            $(".ele_active").height(wrapper_h);
            $(".ele_hide").height(wrapper_h);
            _this._initLoadFirstTabData(tabsContainer,options);
            _this._tabToSwitchEvent(tabsContainer,options);

        },
        _tabToSwitchEvent : function(tabsContainer,options) {
            var _this = this;
            if (tabsContainer.find("div.cmp_tab").find("li").length != 1) {
                tabsContainer.find("div.cmp_tab").find("a").each(function (index) {
                    $(this).on("click",function () {
                        $(this).parent().parent().find("li").siblings().removeClass("cmp_tab_nav_active");
                        $(this).parent('li').addClass("cmp_tab_nav_active");
                        tabsContainer.find(".tab_body").children().removeClass("cmp_ele_active").addClass("cmp_ele_hide");

                        var tabId = $(this).attr("tgt");
                        var $tabWrapper = $("#"+tabId);
                        $tabWrapper.removeClass("cmp_ele_hide").addClass("cmp_ele_active");
                        if($tabWrapper.html().trim().length<=0){
                            $tabWrapper.append(options.tabs[index].containerObj.container);
                            if(options.tabs[index].renderContainerCallback) {
                                options.tabs[index].renderContainerCallback(options.tabs[index].containerObj);
                            }

                        }else {
                            if(options.tabs[index].containerSwitchCallback) {
                                options.tabs[index].containerSwitchCallback();
                            }
                        }
                    });
                });
            } else {
                tabsContainer.find("div.cmp_tab").find("a").toggle(
                    function () {
                        $(this).parent('li').addClass("cmp_tab_nav_active");
                    },
                    function () {
                        $(this).parent('li').removeClass("cmp_tab_nav_active");
                    }
                );
            }
        },
        _initLoadFirstTabData : function(tabsContainer,options) {
            var tabId = tabsContainer.find("div.cmp_tab").find("a:first").attr("tgt");
            var $tabWrapper = $("#"+tabId);
            $tabWrapper.append(options.tabs[0].containerObj.container);
            if(options.tabs[0].renderContainerCallback) {
                options.tabs[0].renderContainerCallback(options.tabs[0].containerObj);
            }
        },
        _getTemplateHtml : function(data,tplPath) {
            var dataTemplateHtmlStr = MUtils.readFileContent(tplPath);
            var dataTemplateHtml = MUtils.tpl(dataTemplateHtmlStr,data);
            return dataTemplateHtml;
        }
    }

    return MContainer_tab;
})();
//MContainer_tab.js e
//MAssDoc.js s
/**
 * Created by Administrator on 2015-5-27.
 * 该组件依赖MContainer_tab,MContainer_list,MCalendar三个组件
 */
var MAssDoc = (function(){
    //关联文档UI对象========================================================================

    var tabContainer = null;//tab容器
    var cooContainer = null;//协同列表容器
    var arcContainer = null;//文档列表容器
    var cooContainerObj = null;//协同容器对象(是一个list)
    var arcContainerObj = null;//文档容器对象（是一个list）

    //下面是用于缓存用的，避免重复请求数据
    var nextCooContainer = {};//下一级协同列表容器
    var nextCooContainerObj = {};//下一级协同列表容器对象
    var nextArcContainer = {};//下一级文档列表容器
    var nextArcContainerObj = {};//下一级文档列表容器对象
    var preCooListCache = {};//缓存前一级的即将被替换掉的协同list
    var nextCooListCache = {};//缓存后一级的即将被替换掉的协同list
    var preArcListCache = {};//缓存前一级的即将被替换掉的文档list
    var nextArcListCache = {};//缓存后一级的即将被替换掉的文档list
    var pageCount4Coo = {};//缓存分页的起始页(协同)
    var pageCount4Arc = {};//缓存分页的起始页(文档)
    var selectDataCache = {};//缓存被选择的数据
    selectDataCache['collaboration'] = [];//协同选择后的缓存
    selectDataCache['archive'] = [];//文档选中后的缓存
    var selectedDataCacheID = {};//缓存被选中的文档ID(避免在搜索时没有回填而导致重复选中)
    selectedDataCacheID['collaboration'] = [];//协同选中后的ID缓存
    selectedDataCacheID['archive'] = [];//文档选中后的ID缓存
    var cooPageNum = 0;//用于协同列表的页面层数的数数
    var arcPageNum = 0;//用于文档列表的页面层数数数

    MAssDocConstant = {
        C_iAssDocFrom_Archive : 5,//来自文档中心
        C_iAssDocFrom_AssociateDocument : 6,//来自关联文档

        C_iMAssDocType_Collaboration :1,//关联文档类型（协同）
        C_iMAssDocType_Archive : 2,//关联文档类型（文档）

        C_iMAssDocPagingNum : 20,//列表分页数

        C_sMAssDocTplPath_CollaborationListLevel1 : '/cmp/plugins/assDoc/tpl/cmp_collaborationList_level1_tpl.html',//协同一级列表模板地址
        C_sMAssDocTplPath_CollaborationListLevel2 : '/cmp/plugins/assDoc/tpl/cmp_collaborationList_level2_tpl.html',//协同二级列表模板地址
        C_sMAssDocTplPath_ArchiveListLevel1:'/cmp/plugins/assDoc/tpl/cmp_archiveList_level1_tpl.html',//文档一级列表模板地址
        C_sMAssDocTplPath_ArchiveListLevel2:'/cmp/plugins/assDoc/tpl/cmp_archiveList_level2_tpl.html',//文档二级列表模板地址
        C_sMAssDocTplPath_searchUiWidget:'/cmp/plugins/assDoc/tpl/cmp_searchUiWidget_tpl.html',//搜索小组件地址
        C_sMAssDocTplPath_searchKeywordType:'/cmp/plugins/assDoc/tpl/cmp_search_keywordType_tpl.html',//搜索模板地址

        C_sMAssDocDefaultImgPath : '/cmp/plugins/assDoc/images'
    }

    MAssDocService = {
        C_sMAssDocServiceBaseUrl: "http://" + document.location.host + "/seeyon/ajax.do?method=ajaxAction",
        C_sMAssDocServiceManagerName_mCollaborationManager: "mCollaborationManager",
        C_sMAssDocServiceMethod_getMCollaborationCount: "getMCollaborationCount",
        C_sMAssDocServiceMethod_loadMoreColList: "loadMoreColList",
        C_sMAssDocServiceMethod_searchCollaborationList : "searchCollaborationList",
        C_sMAssDocServiceManagerName_mArchiveManager: "mArchiveManager",
        C_sMAssDocServiceMethod_getArchiveLibraries: "getArchiveLibraries",
        C_sMAssDocServiceMethod_getArchiveListByProjectType : 'getArchiveListByProjectType',
        C_sMAssDocServiceMethod_searchArchive : "searchArchive"
    }
    var MAssDocOptions = null;
    function MAssDoc(options){
        var _this = this;
        _this.options = $.extend({
            serverURL : "http://" + document.location.host + "/seeyon",
            backfillData : null,
            okCallback : null,
            closeCallback : null
        },options);
        MAssDocOptions = _this.options;
        _this.createAssDocUI();
        _this.bindOkEvent();
        _this.bindCloseEvent();
    };

    MAssDoc.prototype = {
        createAssDocUI : function() {
            var _this = this;
            var el = $(window.document.body);
            var containerUi = getListUi();
            var height = $(window).height();
            containerUi.css("height",height);
            containerUi.appendTo(el);
            _this.widgetUI = containerUi;
            _this.okBtn = $(".okBtn",containerUi);//确定按钮
            _this.closeBtn = $(".headerCloseBtn",containerUi);
            var cooContainerParams = new MListContainerParam({//创建协同列表的参数
                id : "CollaborationContainer",
                listType : 2,
                position : {
                    top : '83px',
                    width : '100%'
                }
            });
            var arcContainerParams = new MListContainerParam({//创建文档列表的参数
                id : "ArchiveContainer",
                listType : 2,
                position : {
                    top : '83px',
                    width : '100%'
                }
            });
            //创建协同一级列表
            cooContainer = new MContainer_list();
            cooContainerObj = cooContainer.createScrollContainer(cooContainerParams);
            //创建文档一级列表
            arcContainer = new MContainer_list();
            arcContainerObj = arcContainer.createScrollContainer(arcContainerParams);
            //创建tab容器
            var tabsParams = new MTabsContainerParam({
                tabsContainerID : 'accDocListWraper',
                tabs : [
                    {
                        tabID : 1,
                        tabName : '协同',
                        containerObj : cooContainerObj,
                        renderContainerCallback : loadCollaborationCallback,
                        containerSwitchCallback : collaborationTabSwitchEvent
                    },
                    {
                        tabID : 2,
                        tabName : '文档',
                        containerObj : arcContainerObj,
                        renderContainerCallback : loadArchiveCallback,
                        containerSwitchCallback : archiveTabSwitchEvent
                    }
                ]
            });
            tabContainer = new MContainer_tab();
            tabContainer.createTabsContainer(tabsParams);
            setTimeout(function(){
                containerUi.addClass("accDocWidget_showState");
                initHandleBackfillData();
            },0);

        },
        bindOkEvent : function() {
            var _this = this;
            _this.okBtn.unbind("click").bind("click",function() {
                var callback = _this.options.okCallback;
                if(callback) {
                    callback(selectDataCache['collaboration'],selectDataCache['archive']);
                }else {
                    _this.close();
                }
            });
        },
        bindCloseEvent : function() {
            var _this = this;
            _this.closeBtn.unbind("click").bind("click",function() {
                var callback = _this.options.closeCallback;
                if(callback) {
                    callback(selectDataCache['collaboration'],selectDataCache['archive']);
                }else {
                    _this.close();
                }

            });
        },
        close : function(){
            var _this = this ;
            tabContainer = null;
            cooContainer = null;
            arcContainer = null;
            cooContainerObj = null;
            arcContainerObj = null;
            nextCooContainer = {};
            nextCooContainerObj = {};
            nextArcContainer = {};
            nextArcContainerObj = {};
            preCooListCache = {};
            nextCooListCache = {};
            preArcListCache = {};
            nextArcListCache = {};
            pageCount4Coo = {};
            pageCount4Arc = {};
            selectDataCache = {};
            selectDataCache['collaboration'] = [];
            selectDataCache['archive'] = [];
            selectedDataCacheID = {};
            selectedDataCacheID['collaboration'] = [];
            selectedDataCacheID['archive'] = [];
            cooPageNum = 0;
            arcPageNum = 0;
            searchContainer = null
            searchContainerObj = null;
            pageCount4Search = 0;
            _this.widgetUI.remove();
            _this = null;

        }
    };


    /*===================================================私有方法===============================*/
    //创建协同数据列表的回调
    function loadCollaborationCallback(containerObj) {
        var listItemOptions = {};
        var CollaborationDataList = {};
        var dataList = [];
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mCollaborationManager,
            MAssDocService.C_sMAssDocServiceMethod_getMCollaborationCount
        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl, requestAjax, function (result) {
            var pendingCount = result.pendingCount;
            var sendCount = result.sendCount;
            var doneCount = result.doneCount;
            var classType = result.classType;
            dataList.push({
                type: classType,
                id : 3,
                title: '待办',
                number: pendingCount
            });
            dataList.push({
                type: classType,
                id: 4,
                title: '已办',
                number: doneCount
            });
            dataList.push({
                type: classType,
                id: 2,
                title: '已发',
                number: sendCount
            });
            CollaborationDataList.data = dataList;
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_CollaborationListLevel1;
            listItemOptions.listData = CollaborationDataList;
            containerObj.renderListData(listItemOptions);
            $("header.headerArea").find(".headerSearch").html('&nbsp;');
        });
    }
    //创建文档数据列表的回调
    function loadArchiveCallback(containerObj){
        var listItemOptions = {};
        var archiveDataList = {};
        var dataList = [];
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mArchiveManager,
            MAssDocService.C_sMAssDocServiceMethod_getArchiveLibraries,
            [MChooseConfig.currentAccountID,MAssDocConstant.C_iAssDocFrom_AssociateDocument]
        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
            dataList = result.value;
            archiveDataList.data = dataList;
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_ArchiveListLevel1;
            listItemOptions.listData = archiveDataList;
            containerObj.renderListData(listItemOptions);
            $("header.headerArea").find(".headerSearch").html('&nbsp;');
        });
    }
    //创建组件ui
    function getListUi() {
        var $html = $('<div class="accDocWidget accDocWidget_hiddenState">' +
            '   <header class="headerArea">' +
            '       <div class="headerCloseBtn"><span class="accDocWidget_uiClose"></span></div>'+
            '       <div class="headerTitle">关联文档</div>' +
            '       <div class="headerSearch">&nbsp;</div>' +
            '   </header>' +
            '   <div class="contentArea">' +
            '       <div class="wrapperl" id="accDocListWraper">' +
            '           <div id="CollaborationContainer" ></div>' +
            '           <div id="ArchiveContainer" ></div>'+
            '       </div>' +
            '   </div>'+
            '   <footer class="footerArea" >' +
            '       <div class="okBtn">确定</div>' +
            '   </footer>'+
            '</div>');
        return $html;
    }
    /*=================================静态方法===========================*/
    /*==================================协同列表的业务逻辑处理=============================================*/
    /**
     * 点击进入下一级协同列表
     * @param dom：列表item
     */
    MAssDoc.toNextLevel_collaboration = function(dom) {
        var affairState = $(dom).attr("id");
        var currentCollInfo = {
            affairState : affairState
        }
        var currentListContainer =  cooContainerObj.container;
        var currentListContainerId = cooContainerObj.containerId;
        var currentListScrollArea = currentListContainer.find("div[id="+currentListContainerId+"_scroller]");
        var footerHeight = $("footer.footerArea").height();
        $("header.headerArea").find(".headerSearch").html('<span class="cmp_btn4Search"></span>');
        if(preCooListCache[affairState] == undefined)
            preCooListCache[affairState] = currentListScrollArea;//缓存当前一级协同列表
        currentListScrollArea.remove();//将当前协同列表删除掉
        if(nextCooListCache[affairState] != null) {//如果下一级的协同列表不为空，就直接将缓存的列表插入进当前容器
            currentListContainer.prepend(nextCooListCache[affairState]);
            cacheSelectedData(currentListContainer,MAssDocConstant.C_iMAssDocType_Collaboration);
            cooPageNum ++;
            toPreLevelEvent(currentListContainer);

        }else {//如果下一级的协同列表不为空，则需要异步创建(避免在tab标签中一次性将所有的数据请求进来)
            var nextCooContainerParams = new MListContainerParam({//创建二级协同列表的参数
                id: "CollaborationContainer",
                listType: 1,//有上拉下拉样式的
                position: {
                    top: '83px',
                    width: '100%',
                    bottom : footerHeight + 'px'
                },
                clickDownLoadMoreDataCallback : loadMoreCollaboration
            });
            nextCooContainer[affairState] = new MContainer_list();
            nextCooContainerObj[affairState] = nextCooContainer[affairState].createScrollContainer(nextCooContainerParams);
            var listItemOptions = {};
            var nextLevelCollaborationDataList = {};
            var requestAjax = MUtils.mRequestAjaxParams(
                MAssDocService.C_sMAssDocServiceManagerName_mCollaborationManager,
                MAssDocService.C_sMAssDocServiceMethod_loadMoreColList,
                [affairState,-1,0,MAssDocConstant.C_iMAssDocPagingNum]
            );
            MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
                var total = 0;
                var dataList = null;
                var dataListSize = 0;
                if(result != null && result != '') {
                    total = result.total;
                    dataList = result.dataList;
                    dataListSize = dataList.length;
                }
                nextLevelCollaborationDataList.affairState = affairState;
                nextLevelCollaborationDataList.accDocType = MAssDocConstant.C_iMAssDocType_Collaboration;
                nextLevelCollaborationDataList.data = dataList;
                nextLevelCollaborationDataList.datasCount = total;
                nextLevelCollaborationDataList.datasLeaveNumber = ((total - dataListSize)<=0)? 0 : (total - dataListSize);
                nextLevelCollaborationDataList.isInit = true;
                nextLevelCollaborationDataList.isSearchWay = false;
                nextLevelCollaborationDataList.container = currentListContainer;
                nextLevelCollaborationDataList.defaultImagePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocDefaultImgPath + '/ic_def_member.png';
                listItemOptions.isTemplate = true;
                listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_CollaborationListLevel2;
                listItemOptions.listData = nextLevelCollaborationDataList;
                nextCooContainerObj[affairState].renderListData(listItemOptions);
                if(nextLevelCollaborationDataList.datasLeaveNumber == 0) {//如果没有下数据则将‘点击加载更多按钮’隐藏，此处可讨论怎样表现比较合适
                    nextCooContainerObj[affairState].container.find("div.clickDown").css("display","none");
                }
                pageCount4Coo[affairState] = 0;
                cacheSelectedData(currentListContainer,MAssDocConstant.C_iMAssDocType_Collaboration);
                cooPageNum ++;
                toPreLevelEvent(currentListContainer);

            });

        }


        searchAssDocData(MAssDocConstant.C_iMAssDocType_Collaboration,currentCollInfo);
    }


    /**
     * 点击加载更多协同列表
     * @param dom:'点击加载更多'按钮
     */
    var loadMoreCollaboration = function(dom){
        var currentListContainer = $(dom).parent("div.scroller").parent();
        var list_data = $(dom).prev("div.list_data");
        var valDom = list_data.find("div.accDocWidget_backBtnArea");
        var affairState = valDom.attr("affairState");
        pageCount4Coo[affairState] ++;//分页数数
        var listItemOptions = {};
        var nextLevelCollaborationDataList = {};
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mCollaborationManager,
            MAssDocService.C_sMAssDocServiceMethod_loadMoreColList,
            [affairState,-1,pageCount4Coo[affairState]*MAssDocConstant.C_iMAssDocPagingNum,MAssDocConstant.C_iMAssDocPagingNum]
        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
            var total = result.total;
            var dataList = result.dataList;
            nextLevelCollaborationDataList.affairState = affairState;
            nextLevelCollaborationDataList.accDocType = MAssDocConstant.C_iMAssDocType_Collaboration;
            nextLevelCollaborationDataList.data = dataList;
            nextLevelCollaborationDataList.datasCount = total;
            nextLevelCollaborationDataList.datasLeaveNumber = ((total - (pageCount4Coo[affairState] +1)*MAssDocConstant.C_iMAssDocPagingNum) <= 0) ? 0 : (total - (pageCount4Coo[affairState] +1)*MAssDocConstant.C_iMAssDocPagingNum);
            nextLevelCollaborationDataList.isInit = false;
            nextLevelCollaborationDataList.container = nextCooContainerObj[affairState].container;
            nextLevelCollaborationDataList.defaultImagePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocDefaultImgPath + '/ic_def_member.png';
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_CollaborationListLevel2;
            listItemOptions.listData = nextLevelCollaborationDataList;
            nextCooContainerObj[affairState].renderListData(listItemOptions);
            if(nextLevelCollaborationDataList.datasLeaveNumber == 0) {
                $(dom).css("display","none");
            }
            toPreLevelEvent(currentListContainer);
            cacheSelectedData(nextCooContainerObj[affairState].container,MAssDocConstant.C_iMAssDocType_Collaboration);
        });

    }

    /*========================================文档列表的业务逻辑处理============================================*/
    /**
     * 点击进入下一级文档列表
     * @param dom:列表item
     */
    MAssDoc.toNextLevel_archive = function(dom){
        var valJson = $(dom).attr("value");
        var valObj = $.parseJSON(valJson);
        var docLibId = (typeof valObj.docLibID != "undefined") ? valObj.docLibID : valObj.archiveID;
        var docLibName = (typeof valObj.name != "undefined") ? valObj.name : valObj.title;
        var projectTypeId = (valObj.projectTypeId == null || typeof valObj.projectTypeId == "undefined" || valObj.projectTypeId == '') ?'' : valObj.projectTypeId;
        var currentArcLibInfo = {
            docLibId:docLibId,
            docLibName : docLibName,
            projectTypeId : projectTypeId
        };
        var footerHeight = $("footer.footerArea").height();
        $("header.headerArea").find(".headerSearch").html('<span class="cmp_btn4Search" ></span>');
        var currentListContainer = arcContainerObj.container;
        var currentListContainerId = arcContainerObj.containerId;
        var currentListScrollArea = currentListContainer.find("div[id="+currentListContainerId+"_scroller]");
        if(preArcListCache[docLibId] == undefined)
            preArcListCache[docLibId] = currentListScrollArea;
        currentListScrollArea.remove();
        if(nextArcListCache[docLibId] != null){
            currentListContainer.prepend(nextArcListCache[docLibId]);
            cacheSelectedData(currentListContainer,MAssDocConstant.C_iMAssDocType_Archive);
            arcPageNum ++;
            toPreLevelEvent(currentListContainer);
        }else {
            var nextArcLibContainerParams = new MListContainerParam({
                id: "ArchiveContainer",
                listType: 1,
                position: {
                    top: '83px',
                    width: '100%',
                    bottom : footerHeight + 'px'
                },
                clickDownLoadMoreDataCallback : loadMoreArchive
            });
            nextArcContainer[docLibId] = new MContainer_list();
            nextArcContainerObj[docLibId] = nextArcContainer[docLibId].createScrollContainer(nextArcLibContainerParams);
            var listItemOptions = {};
            var nextLevelArchiveDataList = {};
            var requestAjax = MUtils.mRequestAjaxParams(
                MAssDocService.C_sMAssDocServiceManagerName_mArchiveManager,
                MAssDocService.C_sMAssDocServiceMethod_getArchiveListByProjectType,
                [docLibId,MAssDocConstant.C_iAssDocFrom_AssociateDocument,0,MAssDocConstant.C_iMAssDocPagingNum,projectTypeId]
            );
            MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
                var dataList = null;
                var total = 0;
                var dataListSize = 0;
                if(result != null && result != "") {
                    dataList = result.dataList;
                    dataListSize = dataList.length;
                    total = result.total;
                }

                nextLevelArchiveDataList.data = dataList;
                nextLevelArchiveDataList.isSearchWay = false;
                nextLevelArchiveDataList.isInit = true;
                nextLevelArchiveDataList.docLibId = docLibId + '';
                nextLevelArchiveDataList.projectTypeId = projectTypeId;
                nextLevelArchiveDataList.docLibName = docLibName;
                nextLevelArchiveDataList.accDocType = MAssDocConstant.C_iMAssDocType_Archive;
                nextLevelArchiveDataList.datasCount = total;
                nextLevelArchiveDataList.container = currentListContainer;
                nextLevelArchiveDataList.datasLeaveNumber = ((total - dataListSize)<=0)? 0 : (total - dataListSize);
                listItemOptions.isTemplate = true;
                listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_ArchiveListLevel2;
                listItemOptions.listData = nextLevelArchiveDataList;
                nextArcContainerObj[docLibId].renderListData(listItemOptions);
                if(nextLevelArchiveDataList.datasLeaveNumber == 0) {
                    nextArcContainerObj[docLibId].container.find("div.clickDown").css("display","none");
                }
                pageCount4Arc[docLibId] = 0;
                cacheSelectedData(currentListContainer,MAssDocConstant.C_iMAssDocType_Archive);
                arcPageNum ++;
                toPreLevelEvent(currentListContainer);
            });
        }
        searchAssDocData(MAssDocConstant.C_iMAssDocType_Archive,currentArcLibInfo);

    }
    var loadMoreArchive = function(dom){
        var currentListContainer = $(dom).parent("div.scroller").parent();
        var list_data = $(dom).prev("div.list_data");
        var valDom = list_data.find("div.accDocWidget_backBtnArea");
        var docLibId = valDom.attr("docLibId");
        var projectTypeId = valDom.attr("projectTypeId");
        pageCount4Arc[docLibId] ++;
        var listItemOptions = {};
        var nextLevelArchiveDataList = {};
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mArchiveManager,
            MAssDocService.C_sMAssDocServiceMethod_getArchiveListByProjectType,
            [
                docLibId,
                MAssDocConstant.C_iAssDocFrom_AssociateDocument,
                    pageCount4Arc[docLibId]*MAssDocConstant.C_iMAssDocPagingNum,
                MAssDocConstant.C_iMAssDocPagingNum,
                projectTypeId
            ]
        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
            var dataList = result.dataList;
            var total = result.total;
            nextLevelArchiveDataList.data = dataList;
            nextLevelArchiveDataList.isInit = false;
            nextLevelArchiveDataList.docLibId = docLibId + '';
            nextLevelArchiveDataList.docLibName = nextLevelArchiveDataList;
            nextLevelArchiveDataList.accDocType = MAssDocConstant.C_iMAssDocType_Archive;
            nextLevelArchiveDataList.datasCount = total;
            nextLevelArchiveDataList.container = nextArcContainerObj[docLibId].container;
            nextLevelArchiveDataList.datasLeaveNumber = ((total - (pageCount4Arc[docLibId] + 1)*MAssDocConstant.C_iMAssDocPagingNum)<=0)? 0 : (total - (pageCount4Arc[docLibId] + 1)*MAssDocConstant.C_iMAssDocPagingNum);
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_ArchiveListLevel2;
            listItemOptions.listData = nextLevelArchiveDataList;
            nextArcContainerObj[docLibId].renderListData(listItemOptions);
            if(nextLevelArchiveDataList.datasLeaveNumber == 0) {
                nextArcContainerObj[docLibId].container.find("div.clickDown").css("display","none");
            }
            toPreLevelEvent(currentListContainer);
            cacheSelectedData(nextArcContainerObj[docLibId].container,MAssDocConstant.C_iMAssDocType_Archive);
        });
    }
    /*======================返回上一级，通用方法================*/
    //协同页签的切换事件（已经加载数据了）
    function collaborationTabSwitchEvent() {
        if(cooPageNum <= 0) {
            $("header.headerArea").find(".headerSearch").html('&nbsp;');
        }else {
            $("header.headerArea").find(".headerSearch").html('<span class="cmp_btn4Search"></span>');
            var affairState = $("div.accDocWidget").children("div.contentArea").find("#CollaborationContainer").find("div.accDocWidget_backBtnArea").attr("affairstate");
            var currentCollInfo = {
                affairState : affairState
            }
            searchAssDocData(MAssDocConstant.C_iMAssDocType_Collaboration,currentCollInfo);
        }
    }
    //文档页签的切换事件（已经加载了数据了）
    function archiveTabSwitchEvent() {
        if(arcPageNum <= 0) {
            $("header.headerArea").find(".headerSearch").html('&nbsp;');
        }else {
            $("header.headerArea").find(".headerSearch").html('<span class="cmp_btn4Search"></span>');
            var valueDom = $("div.accDocWidget").children("div.contentArea").find("#ArchiveContainer").find("div.accDocWidget_backBtnArea");
            var docLibId = valueDom.attr("docLibId");
            var docLibName = valueDom.attr("docLibName");
            var projectTypeId = valueDom.attr("projectTypeId");
            var currentArcLibInfo = {
                docLibId:docLibId,
                docLibName : docLibName,
                projectTypeId : projectTypeId
            };
            searchAssDocData(MAssDocConstant.C_iMAssDocType_Archive,currentArcLibInfo);
        }
    }
    //返回上一级事件
    function toPreLevelEvent(currentListContainer) {
        var currentBackBtn = currentListContainer.find("div.backBtn");
        currentBackBtn.$click(function() {
            var toPreLevelParam = $.parseJSON(currentBackBtn.attr("toPreLevelParam"));
            var accDocType = toPreLevelParam.accDocType;
            var affairState = toPreLevelParam.affairState;
            var isSearchWay = toPreLevelParam.isSearchWay;
            toPreLevel(currentBackBtn,accDocType,affairState,isSearchWay);
            if(accDocType == MAssDocConstant.C_iMAssDocType_Archive){
                toPreLevelEvent(currentListContainer);
            }
        });
    }
    toPreLevel = function(dom,accDocType,uniqueID,isSearchWay){
        var currentListContainer = null;
        var currentListScrollArea = null;
        if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration) {
            currentListContainer = nextCooContainerObj[uniqueID].container;
            currentListScrollArea = currentListContainer.find("div[id="+nextCooContainerObj[uniqueID].containerId+"_scroller]");
            if(!isSearchWay)
                nextCooListCache[uniqueID] = currentListScrollArea;
            currentListScrollArea.remove();
            currentListContainer.prepend(preCooListCache[uniqueID]);
            cooPageNum --;
            if(cooPageNum <= 0) $("header.headerArea").find(".headerSearch").html('&nbsp;');
            var currentCollInfo = {
                affairState : uniqueID
            }
            searchAssDocData(MAssDocConstant.C_iMAssDocType_Collaboration,currentCollInfo);

        }else if(accDocType == MAssDocConstant.C_iMAssDocType_Archive) {
            currentListContainer = nextArcContainerObj[uniqueID].container;
            currentListScrollArea = currentListContainer.find("div[id="+nextArcContainerObj[uniqueID].containerId+"_scroller]");
            if(!isSearchWay)
                nextArcListCache[uniqueID] = currentListScrollArea;
            currentListScrollArea.remove();
            currentListContainer.prepend(preArcListCache[uniqueID]);
            arcPageNum --;
            if(arcPageNum <= 0)
                $("header.headerArea").find(".headerSearch").html('&nbsp;');
            var valueDom = preArcListCache[uniqueID].find("div.accDocWidget_backBtnArea");
            var docLibId = valueDom.attr("docLibId");
            var docLibName = valueDom.attr("docLibName");
            var projectTypeId = valueDom.attr("projectTypeId");
            var currentArcLibInfo = {
                docLibId:docLibId,
                docLibName : docLibName,
                projectTypeId : projectTypeId
            };
            searchAssDocData(MAssDocConstant.C_iMAssDocType_Archive,currentArcLibInfo)
        }

        cacheSelectedData(currentListContainer,accDocType);

    }
    /*=========================查询相关===================================================================*/
    /**
     * 查询关联文档数据
     * @param accDocType：数据类型1：协同；2：文档
     * @param currentDocInfo：查询的归类的信息：如果是协同则是一个唯一标识ID，如果是文档则是一个对象信息
     */
    function searchAssDocData(accDocType,currentDocInfo) {
        var accDocWidget = $("div.accDocWidget");
        var searchBtn = accDocWidget.find("div.headerSearch");
        if(searchBtn.find("span.cmp_btn4Search").length > 0) {
            searchBtn.off("click").on("click",function() {
                showSearchUI(accDocWidget,accDocType,currentDocInfo);
            });
        }else {
            searchBtn.die("click");
        }
    }
    //显示查询小组件(目前有对缓存机制的BUG需要修改)
    function showSearchUI(accDocWidget,accDocType,currentDocInfo) {
        var top  = accDocWidget.scrollTop();
        var searchWidget = createSearchUI();
        searchWidget.css("top",top);
        var uniqueID = "";
        if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration) {
            uniqueID = currentDocInfo.affairState;
        }else {
            uniqueID = currentDocInfo.docLibId;

        }
        searchWidget.find("div.title").attr("uniqueID",uniqueID);
        searchWidget.appendTo(accDocWidget);
        var headerTile = $(".headerTitle",searchWidget);
        var returnBtn = $(".headerCloseBtn2",searchWidget);
        var titleArea = $(".titleArea",searchWidget);
        var keywordTypeArea = $(".keywordTypeArea",searchWidget);
        var keywordInputArea = $(".keywordInputArea",searchWidget);
        var list = $(".list",keywordTypeArea);
        var headerTitleVal = "";
        if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration) {
            titleArea.find("div.title").attr("value","3");  //需要对查询方式赋初始值，协同默认是标题查询
            switch (currentDocInfo.affairState){
                case "3":
                    headerTitleVal = '待办协同搜索';
                    break;
                case "4":
                    headerTitleVal = '已办协同搜索';
                    break;
                case "2":
                    headerTitleVal = '已发协同搜索';
                    break;
                default :
                    break;
            }
            headerTile.html('<span>'+headerTitleVal+'</span>');
        }else {
            titleArea.find("div.title").attr("value","1");//需要对查询方式赋初始值，文档默认是标题查询
            headerTile.html('<span>'+currentDocInfo.docLibName+'搜索</span>');
        }
        titleArea.off("click").on("click",function() {  //查询类型的单选列表显示
            if(keywordTypeArea.hasClass("accDocWidget_searchContainer_hidden")) {
                keywordTypeArea.removeClass("accDocWidget_searchContainer_hidden").addClass("accDocWidget_searchContainer_show");
                titleArea.find("span").removeClass("cmp_downward").addClass("cmp_topward");
                var searchTypeData = {};
                var backValue = titleArea.find("div.title").attr("value");
                searchTypeData.assDataType = accDocType;
                searchTypeData.docInfo = currentDocInfo;
                var keywordTypeTplPath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_searchKeywordType;
                var tplStr = MUtils.readFileContent(keywordTypeTplPath);
                var html = MUtils.tpl(tplStr,searchTypeData);
                list.append(html);
                if(typeof backValue != "undefined") {
                    list.find("input[type=radio]").each(function() {
                        var value = $(this).val();
                        if(backValue == value) $(this)[0].checked = true;
                    });
                }else {
                    list.find("input[type=radio]:first")[0].checked = true;
                }
                bindSearchTypeChooseEvent(list);
            }else if(keywordTypeArea.hasClass("accDocWidget_searchContainer_show")) {
                titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
                list.html("");
                keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");
            }
        });
        returnBtn.off("click").on("click",function() {
            searchWidget.remove();
            searchWidget = null;
        });
        keywordInputArea.off("click").on("click",function() {
            if(keywordTypeArea.hasClass("accDocWidget_searchContainer_show")) {
                titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
                list.html("");
                keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");
            }
        });
        bindSearchActionEvent(searchWidget,accDocType,currentDocInfo);

    }
    //绑定查询类型的选择事件
    function bindSearchTypeChooseEvent(listUi) {
        listUi.children("div.listItem").off("click").on("click",function() {
            var radio = $(this).find("input[type=radio]");
            var keywordTypeArea = $(this).parent().parent();
            var titleArea = keywordTypeArea.prev("div.titleArea");
            var keywordInputArea = keywordTypeArea.next("div.keywordInputArea");
            radio[0].checked = true;
            var value = radio.val();
            var uniqueID = $(this).attr("uniqueID");
            var keywordName = $(this).find("div.keywordName").html();
            titleArea.find("div.title").html(keywordName).attr("value",value).attr("uniqueID",uniqueID);
            titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
            if(value == 2) {
                var dateUI = createDateUI();
                keywordInputArea.html(dateUI);
                var startDate = $(".startDate",keywordInputArea);
                var endDate = $(".endDate",keywordInputArea);
                handleDateSearchMethod(startDate,endDate);//单独处理日期方式的搜索

            }else {
                keywordInputArea.html('<div class="inputBox"><input type="text" placeholder="请输入关键字" class="search" id="search"></div>');
            }
            listUi.html("");
            keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");
        });
    }
    //绑定查询动作事件（开始查询以及查询值的处理,搜索的页面不做缓存处理）
    var searchContainer = null //暂时没考虑tab切换的缓存（目前是搜索的都不做缓存）
    var searchContainerObj = null;
    var pageCount4Search = 0;
    function bindSearchActionEvent(searchWidget,accDocType,currentDocInfo) {
        var searchBtn = searchWidget.find("div.searchActionArea").find("div.searchBtn");
        var title = searchWidget.find("div.titleArea").find("div.title");
        var keyword = "";
        searchBtn.off("click").on("click",function() {
            var uniqueID = "";
            if(searchContainer != null) searchContainer = null;
            if(searchContainerObj != null) searchContainerObj = null;
            var titleValue = title.attr("value");
            var keywordInputs = searchWidget.find("div.keywordInputArea").find("input");
            if(keywordInputs.length > 1) { //是日期查询
                var startTime = keywordInputs[0].value;
                var endTime = keywordInputs[1].value;
                if(new Date(endTime.replace(/-/g, "//")) < new Date(startTime.replace(/-/g, "//"))){
                    $.alert("结束时间不能小于开始时间");
                    return ;
                }
                keyword = startTime + "#" + endTime;
            }else {
                keyword = keywordInputs[0].value;
            }
            if(keyword != "" && keyword.length > 0) {
                var requestAjax = "";
                if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration) { //如果是搜索协同
                    uniqueID = currentDocInfo.affairState
                    requestAjax = MUtils.mRequestAjaxParams(
                        MAssDocService.C_sMAssDocServiceManagerName_mCollaborationManager,
                        MAssDocService.C_sMAssDocServiceMethod_searchCollaborationList,
                        [uniqueID,titleValue,keyword,MAssDocConstant.C_iMAssDocPagingNum,0]
                    );
                }else if(accDocType == MAssDocConstant.C_iMAssDocType_Archive) {//如果是搜索文档
                    uniqueID = currentDocInfo.docLibId;
                    requestAjax = MUtils.mRequestAjaxParams(
                        MAssDocService.C_sMAssDocServiceManagerName_mArchiveManager,
                        MAssDocService.C_sMAssDocServiceMethod_searchArchive,
                        [[keyword],MAssDocConstant.C_iAssDocFrom_AssociateDocument,titleValue,uniqueID,0,MAssDocConstant.C_iMAssDocPagingNum]
                    );
                }

                MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
                    searchWidget.remove();
                    searchWidget = null;
                    var currentListContainer,currentListContainerId,currentListScrollArea;
                    var searchContainerParams;
                    var listItemOptions = {};
                    var searchDataList = {};
                    var footerHeight = $("footer.footerArea").height();
                    var dataList = null;
                    var total = 0;
                    var dataListSize = 0;
                    if(result != null && result != "") {
                        dataList = result.dataList;
                        dataListSize = dataList.length;
                        total = result.total;
                    }
                    if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration){
                        currentListContainer = cooContainer.container;
                        currentListContainerId = cooContainerObj.containerId;
                        currentListScrollArea = currentListContainer.find("div[id="+currentListContainerId+"_scroller]");
                        currentListScrollArea.remove();//将当前协同列表删除掉
                        searchContainerParams = new MListContainerParam({
                            id: "CollaborationContainer",
                            listType: 1,//有上拉下拉样式的
                            position: {
                                top: '83px',
                                width: '100%',
                                bottom : footerHeight + 'px'
                            },
                            clickDownLoadMoreDataCallback : loadMoreCollaboration4Search
                        });
                        searchDataList.datasCount = result.total;
                        searchDataList.datasLeaveNumber = ((total - dataList.length) <= 0) ? 0 : (total - dataList.length);
                        searchDataList.data = dataList;
                        searchDataList.defaultImagePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocDefaultImgPath + '/ic_def_member.png';
                        searchDataList.affairState = uniqueID;
                        searchDataList.container = currentListContainer;
                        searchDataList.isInit = true;
                        searchDataList.isSearchWay = true;
                        searchDataList.keyword = keyword;
                        searchDataList.searchMethod = titleValue;
                        searchDataList.accDocType = MAssDocConstant.C_iMAssDocType_Collaboration;
                        listItemOptions.isTemplate = true;
                        listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_CollaborationListLevel2;
                        listItemOptions.listData = searchDataList;
                        pageCount4Search = 0;

                    }else {
                        currentListContainer = arcContainer.container;
                        currentListContainerId = arcContainerObj.containerId;
                        currentListScrollArea = currentListContainer.find("div[id="+currentListContainerId+"_scroller]");
                        currentListScrollArea.remove();
                        searchContainerParams = new MListContainerParam({
                            id: "ArchiveContainer",
                            listType: 1,
                            position: {
                                top: '83px',
                                width: '100%',
                                bottom : footerHeight + 'px'
                            },
                            clickDownLoadMoreDataCallback : loadMoreArchive4Search
                        });
                        searchDataList.data = dataList;
                        searchDataList.isSearchWay = true;
                        searchDataList.keyword = keyword;
                        searchDataList.searchMethod = titleValue;
                        searchDataList.isInit = true;
                        searchDataList.docLibId = uniqueID + '';
                        searchDataList.projectTypeId = currentDocInfo.projectTypeId;
                        searchDataList.docLibName = currentDocInfo.docLibName;
                        searchDataList.accDocType = MAssDocConstant.C_iMAssDocType_Archive;
                        searchDataList.datasCount = total;
                        searchDataList.container = currentListContainer;
                        searchDataList.datasLeaveNumber = ((total - dataListSize)<=0)? 0 : (total - dataListSize);
                        listItemOptions.isTemplate = true;
                        listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_ArchiveListLevel2;
                        listItemOptions.listData = searchDataList;
                        pageCount4Search = 0;

                    }
                    searchContainer = new MContainer_list();
                    searchContainerObj= searchContainer.createScrollContainer(searchContainerParams);
                    searchContainer.renderListData(listItemOptions);
                    if(searchDataList.datasLeaveNumber == 0) {//如果没有下数据则将‘点击加载更多按钮’隐藏，此处可讨论怎样表现比较合适
                        searchContainer.container.find("div.clickDown").css("display","none");
                    }
                    toPreLevelEvent(currentListContainer);
                    cacheSelectedData(currentListContainer,accDocType);
                });
            }
        });

    }
    /**
     * 点击加载更多协同列表
     * @param dom:'点击加载更多'按钮
     */
    var loadMoreCollaboration4Search = function(dom){
        var currentListContainer = $(dom).parent("div.scroller").parent();
        var list_data = $(dom).prev("div.list_data");
        var valDom = list_data.find("div.accDocWidget_backBtnArea");
        var affairState = valDom.attr("affairState");
        var keyword = valDom.attr("keyword");
        var searchMethod = valDom.attr("searchMethod");
        pageCount4Search ++;//分页数数
        var listItemOptions = {};
        var nextLevelCollaborationDataList = {};
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mCollaborationManager,
            MAssDocService.C_sMAssDocServiceMethod_searchCollaborationList,
            [affairState,searchMethod,keyword,MAssDocConstant.C_iMAssDocPagingNum,pageCount4Search*MAssDocConstant.C_iMAssDocPagingNum]
        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
            var total = result.total;
            var dataList = result.dataList;
            nextLevelCollaborationDataList.affairState = affairState;
            nextLevelCollaborationDataList.accDocType = MAssDocConstant.C_iMAssDocType_Collaboration;
            nextLevelCollaborationDataList.data = dataList;
            nextLevelCollaborationDataList.datasCount = total;
            nextLevelCollaborationDataList.datasLeaveNumber = ((total - (pageCount4Search +1)*MAssDocConstant.C_iMAssDocPagingNum) <= 0) ? 0 : (total - (pageCount4Search +1)*MAssDocConstant.C_iMAssDocPagingNum);
            nextLevelCollaborationDataList.isInit = false;
            nextLevelCollaborationDataList.container = searchContainerObj.container;
            nextLevelCollaborationDataList.defaultImagePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocDefaultImgPath + '/ic_def_member.png';
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_CollaborationListLevel2;
            listItemOptions.listData = nextLevelCollaborationDataList;
            searchContainerObj.renderListData(listItemOptions);
            if(nextLevelCollaborationDataList.datasLeaveNumber == 0) {
                $(dom).css("display","none");
            }
            toPreLevelEvent(currentListContainer);
            cacheSelectedData(searchContainerObj.container,MAssDocConstant.C_iMAssDocType_Collaboration);
        });

    }
    var loadMoreArchive4Search = function(dom){
        var currentListContainer = $(dom).parent("div.scroller").parent();
        var list_data = $(dom).prev("div.list_data");
        var valDom = list_data.find("div.accDocWidget_backBtnArea");
        var docLibId = valDom.attr("docLibId");
        var keyword = valDom.attr("keyword");
        var searchMethod = valDom.attr("searchMethod")
        pageCount4Search ++;
        var listItemOptions = {};
        var nextLevelArchiveDataList = {};
        var requestAjax = MUtils.mRequestAjaxParams(
            MAssDocService.C_sMAssDocServiceManagerName_mArchiveManager,
            MAssDocService.C_sMAssDocServiceMethod_searchArchive,
            [[keyword],MAssDocConstant.C_iAssDocFrom_AssociateDocument,searchMethod,docLibId,pageCount4Search*MAssDocConstant.C_iMAssDocPagingNum,MAssDocConstant.C_iMAssDocPagingNum]

        );
        MUtils.mRequestForAjax(MAssDocService.C_sMAssDocServiceBaseUrl,requestAjax,function(result){
            var dataList = result.dataList;
            var total = result.total;
            nextLevelArchiveDataList.data = dataList;
            nextLevelArchiveDataList.isInit = false;
            nextLevelArchiveDataList.docLibId = docLibId + '';
            nextLevelArchiveDataList.docLibName = nextLevelArchiveDataList;
            nextLevelArchiveDataList.accDocType = MAssDocConstant.C_iMAssDocType_Archive;
            nextLevelArchiveDataList.datasCount = total;
            nextLevelArchiveDataList.container = searchContainerObj.container;
            nextLevelArchiveDataList.datasLeaveNumber = ((total - (pageCount4Search + 1)*MAssDocConstant.C_iMAssDocPagingNum)<=0)? 0 : (total - (pageCount4Search + 1)*MAssDocConstant.C_iMAssDocPagingNum);
            listItemOptions.isTemplate = true;
            listItemOptions.listItemTemplatePath = MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_ArchiveListLevel2;
            listItemOptions.listData = nextLevelArchiveDataList;
            searchContainerObj.renderListData(listItemOptions);
            if(nextLevelArchiveDataList.datasLeaveNumber == 0) {
                searchContainerObj.container.find("div.clickDown").css("display","none");
            }
            toPreLevelEvent(currentListContainer);
            cacheSelectedData(searchContainerObj.container,MAssDocConstant.C_iMAssDocType_Archive);
        });
    }

    /**
     * 处理日期方式的搜索
     * @param startDateInput：开始时间输入域
     * @param endDateInput：结束事件输入域
     */

    function handleDateSearchMethod(startDateInput,endDateInput) {
        var startCalendar = null;
        var endCalendar = null
        var nowDate = new Date();
        var year = nowDate.getFullYear();
        var month = nowDate.getMonth() +1;
        var date = nowDate.getDate();
        month = month < 10 ?"0" + month : month;
        date = date < 10 ? "0" + date : date;
        var formatDate = year + "-" + month + "-" + date;
        startDateInput.val(formatDate);
        endDateInput.val(formatDate);
        startDateInput.addClass("dateInputActive").addClass("initAction");
        var startDateOptions = {
            okCallback : function(formatDate){
                startDateInput.val(formatDate);
                if(startDateInput.hasClass('initAction')) startDateInput.removeClass("initAction");
                startCalendar = null;
            },
            clearCallback : function() {
                startDateInput.val("");
                if(startDateInput.hasClass('initAction')) startDateInput.removeClass("initAction");
                startCalendar = null;
            }
        }
        var endDateOptions = {
            okCallback : function(formatDate){
                endDateInput.val(formatDate);
                endCalendar = null;
            },
            clearCallback : function() {
                endDateInput.val("");
                endCalendar = null;
            }
        }
        if(startDateInput.hasClass("initAction")) {
            startCalendar = new MCalendar(startDateInput,startDateOptions);
            startCalendar.showDateWidget();
        }
        startDateInput.unbind("click").bind("click",function() {
            if(endDateInput.hasClass("dateInputActive")){
                endDateInput.removeClass("dateInputActive");
                startDateInput.addClass("dateInputActive");
            }
            startCalendar = new MCalendar(startDateInput,startDateOptions);
            startCalendar.showDateWidget();
        });

        endDateInput.unbind("click").bind("click",function() {
            if(startDateInput.hasClass("dateInputActive")){
                startDateInput.removeClass("dateInputActive");
                endDateInput.addClass("dateInputActive");
            }
            endCalendar = new MCalendar(endDateInput,endDateOptions);
            endCalendar.showDateWidget();
        });
    }
    //创建搜索小组件ui
    function createSearchUI() {
        var searchUiWidgetHtml = MUtils.readFileContent(MAssDocOptions.serverURL + MAssDocConstant.C_sMAssDocTplPath_searchUiWidget);
        var $search = $(searchUiWidgetHtml);
        var winHeight = $(window).height();
        var headerHeight = $("header.headerArea").height();
        $search.css("height",winHeight - headerHeight);
        var searchContainerHeight = $("div.accDocWidget_searchContainer").height();
        $("div.accDocWidget_shieldLayer",$search).css("height",(winHeight - headerHeight - searchContainerHeight));
        return $search;
    }
    function createDateUI() {
        var linkageDateUIHtml = '<div class="dateUiArea">' +
            '   <div class="dateInputBox"><input type="text" class="startDate" id="startDate"></div>' +
            '   <div class="dateInputBoxLink"><span>至</span></div>'+
            '   <div class="dateInputBox"><input type="text" class="endDate" id="endDate"></div>' +
            '</div>';
        return linkageDateUIHtml;
    }

    /*=======================================数据处理相关==============================================*/
    //缓存被选中的数据
    function cacheSelectedData(currentContainer,accDocType) {
        var listDataContainer = currentContainer.find("div.list_data");
        //处理有回填值的是否被选中的处理
        var backfillCollaborationIDCache = null;
        var backfillArchiveIDCache = null;
        var selectedCollaborationIDCache = null;
        var selectedArchiveIDCache = null;
        if(MAssDocOptions.backfillData != null) {
            backfillCollaborationIDCache = MAssDocOptions.backfillData['collaborationID'];
            backfillArchiveIDCache = MAssDocOptions.backfillData['archiveID'];
        }

        if(selectedDataCacheID['collaboration'].length > 0) {
            selectedCollaborationIDCache = selectedDataCacheID['collaboration'];
        }
        if(selectedArchiveIDCache = selectedDataCacheID['archive'].length > 0) {
            selectedArchiveIDCache = selectedDataCacheID['archive']
        }

        listDataContainer.find("span.accDocWidget_checkbox").each(function(){
            var checkbox = $(this).find("input[type=checkbox]");
            var id = -1;
            var index1 = -1;
            var index2 = -2;
            if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration) {
                id = checkbox.attr("id").replace("collaboration_","");
                if(backfillCollaborationIDCache != null && backfillCollaborationIDCache.length > 0) {
                    index1 = $.inArray(id,backfillCollaborationIDCache);
                    if(index1 != -1) {
                        checkbox[0].checked = true;
                    }
                }
                if(selectedCollaborationIDCache != null && selectedCollaborationIDCache.length > 0) {
                    index2 = $.inArray(id,selectedCollaborationIDCache);
                    if(index2 != -1) {
                        checkbox[0].checked = true;
                    }
                }


            }else if(accDocType == MAssDocConstant.C_iMAssDocType_Archive){
                id = checkbox.attr("id").replace("archive_","");
                if(backfillArchiveIDCache != null && backfillArchiveIDCache.length > 0) {
                    index1 = $.inArray(id,backfillArchiveIDCache);
                    if(index1 != -1) {
                        checkbox[0].checked = true;
                    }
                }
                if(selectedArchiveIDCache != null && selectedArchiveIDCache.length > 0) {
                    index2 = $.inArray(id,selectedArchiveIDCache);
                    if(index2 != -1) {
                        checkbox[0].checked = true;
                    }
                }
            }
            var assDocItem = $(this).parents('div.assDocItem');
            assDocItem.$click(function() {
                var value = $.parseJSON(checkbox.attr("value"));
                if(checkbox[0].checked == true){
                    checkbox[0].checked = false;
                    if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration){
                        selectDataCache['collaboration'].cmpArraySimpleRemove(value);
                        selectedDataCacheID['collaboration'].cmpArraySimpleRemove(id);
                    }else if(accDocType == MAssDocConstant.C_iMAssDocType_Archive) {
                        selectDataCache['archive'].cmpArraySimpleRemove(value);
                        selectedDataCacheID['archive'].cmpArraySimpleRemove(id);
                    }
                }else {
                    checkbox[0].checked = true;
                    if(accDocType == MAssDocConstant.C_iMAssDocType_Collaboration){
                        selectDataCache['collaboration'].push(value);
                        selectedDataCacheID['collaboration'].push(id);
                    }else if(accDocType == MAssDocConstant.C_iMAssDocType_Archive) {
                        selectDataCache['archive'].push(value);
                        selectedDataCacheID['archive'].push(id);
                    }
                }
            });

        });

    }
    //初始化处理回填值（存入缓存）
    function initHandleBackfillData() {
        var backfillData = MAssDocOptions.backfillData;
        if(backfillData != null) {
            var backfillCollaborationCache = MAssDocOptions.backfillData['collaboration'];
            var backfillArchive = MAssDocOptions.backfillData['archive'];
            if(backfillCollaborationCache.length > 0){
                selectDataCache['collaboration'] = backfillCollaborationCache;
            }
            if(backfillArchive.length > 0) {
                selectDataCache['archive'] = backfillArchive;
            }
        }
    }
    Array.prototype.cmpArraySimpleRemove = function(value) {
        var valueResult = '';
        var thisValResult = '';
        for(var i = 0 ; i < this.length; i ++) {
            if(typeof value == 'object' && typeof this[i] == 'object'){
                valueResult = $.toJSON(value);
                thisValResult = $.toJSON(this[i]);
            }else {
                valueResult = value;
                thisValResult = this[i];
            }
            if(valueResult === thisValResult) {
                this.splice(i,1);
            }
        }
    }
    return MAssDoc;

})();
//MAssDoc.js e
//MAssForm.js s
/**
 * Created by Administrator on 2015-6-3.
 * 依赖日历组件和选人组件
 */
var MAssForm = (function() {
    var accFormMainScroller = null;//横向滚动的主scroller
    var mainContentScroller = null;//内容区域纵向滚动的scroller
    var searchTypeAreaScroller = null;//搜索类型区域的滚动scroller（保证只能有一个，避免产生过多得scroller对象）
    var pageCount_default = 0;//缓存分页起始页
    var pageCount_search = 0;//缓存搜索的起始页
    var toFormBean = null;//缓存关键属性（该属性需要传到桥接器处进行处理，在该组件里面不进行处理）(是一个json格式数据)
    var columnListMap = null;//缓存表头字段
    var pullDownUI = null;//下拉ui
    var clickDownUI = null;//点击ui
    MAssFormConstant = {
        C_iMAssFormFormType_flowForm : 1,//流程表单
        C_iMAssFormFormType_noFlowForm : 2,//无流程表单
        C_iMAssFormFormType_basicInfo : 3,//基础信息表单

        C_iMAssFormPagingNum : 20,//列表分页数

        C_sMAssFormTplPath_assFormColumnList : '/cmp/plugins/assDoc/tpl/cmp_assFormColumnList_tpl.html',//渲染表头的模板
        C_sMAssFormTplPath_assFormFormList : '/cmp/plugins/assDoc/tpl/cmp_assFormFormList_tpl.html',//渲染表单列表的模板
        C_sMAssFormTplPath_searchUiWidget : '/cmp/plugins/assDoc/tpl/cmp_searchUiWidget_tpl.html',//搜索组件模板
        C_sMAssFormTplPath_searchKeywordType : '/cmp/plugins/assDoc/tpl/cmp_search_keywordType4AssForm_tpl.html',//渲染搜索类型的列表模板
        C_sMAssFormTplPath_assFormItem : '/cmp/plugins/assDoc/tpl/cmp_assFormFormItem_tpl.html',
        C_sMAssFormTplPath_assFormCheckboxItem : '/cmp/plugins/assDoc/tpl/cmp_assFormCheckboxItem_tpl.html',

        C_iMAssFormSearchKeywordTypeAreaHeight : 150//搜索类型的区域的滚动高度

    }
    MAssFormService = {
        C_sMAssFormServiceBaseUrl: "http://" + document.location.host + "/seeyon/ajax.do?method=ajaxAction",
        C_sMAssFormServiceManagerName_mFormManager : "mFormManager",
        C_sMAssFormServiceMethod_getNoFlowRelationFormBasicInfo : 'getNoFlowRelationFormBasicInfo',
        C_sMAssFormServiceMethod_getFlowRelationFormBasicInfo : 'getFlowRelationFormBasicInfo',
        C_sMAssFormServiceMethod_loadMoreFormData : 'loadMoreFormDataForLatestVersion'
    }
    var MAssFormOptions = null;//关联表单配置属性
    function MAssForm(options) {
        var _this = this;
        _this.options = $.extend({
            serverURL : "http://" + document.location.host + "/seeyon",//环境主地址
            relationParams : null,//关联数据（对象）
            currentAccountID : null,//登录人员id（根据创建人搜索表单时需要）
            okCallback : null,//确定回调
            closeCallback : null//关闭组件的回调
        },options);
        MAssFormOptions = _this.options;
        _this.createAssFormUI();
    }
    MAssForm.prototype = {
        createAssFormUI : function() {
            var _this = this;
            var el = $(window.document.body);
            var containerUI = getListUI();
            var height = $(window).height();
            containerUI.css("height",height);
            containerUI.appendTo(el);
            _this.widgetUI = $(containerUI);
            _this.accFormMainScroller = $("#accFormMainScroller",_this.widgetUI);//横向主滚动区
            _this.contentMainArea = $("#contentMainArea",_this.widgetUI);//纵向表单列表滚动区
            _this.transversePage = $("#transversePage",_this.widgetUI);//横向内容区
            _this.contentTitleArea = $("#contentTitleArea",_this.widgetUI);//表头区域
            _this.okBtn = $(".okBtn",_this.widgetUI);//确定按钮
            _this.closeBtn = $(".headerCloseBtn",_this.widgetUI);//关闭按钮
            _this.searchBtn = $(".headerSearch",_this.widgetUI);//搜索按钮
            var relationParams = _this.options.relationParams;
            var relation = relationParams.relation;

            var formType = relationParams.formType;
            var assFormParams = "";
            var requestAjax = "";
            try{
                var relationObj = $.parseJSON(relation);
                var id = relationObj.id;
                var recodeID = relationParams.recodeID;
                var isNew = relationObj.new;
                var contentDataID = relationParams.contentDataID;
                var toRelationObjType = relationObj.toRelationObjType;
                var toRelationObj = relationObj.toRelationObj;
                var toRelationAttrType = relationObj.toRelationAttrType;
                var toRelationAttr = relationObj.toRelationAttr;
                var sysRelationForm = relationObj.sysRelationForm;
                var formRelation = relationObj.formRelation;
                var formRelationField = relationObj.formRelationField;
                var fromRelationObj = relationObj.fromRelationObj;
                var fromRelationAttr = relationObj.fromRelationAttr;
                var formRelationFlow = relationObj.formRelationFlow;
                var viewAttr = relationObj.viewAttr;
                var viewSelectType = relationObj.viewSelectType;
                var viewType = relationObj.viewType;
                var viewConditionId = relationObj.viewConditionId;
                var dataRelationImageEnum = relationObj.dataRelationImageEnum;
                var dataRelationMember = relationObj.dataRelationMember;
                var dataRelationDepartment = relationObj.dataRelationDepartment;
                var dataRelationMultiEnum = relationObj.dataRelationMultiEnum;
                var dataRelationLbs = relationObj.dataRelationLbs;
                var dataRelationMap = relationObj.dataRelationMap;
                var dataRelationProject = relationObj.dataRelationProject;
                var dataExchangeTask = relationObj.dataExchangeTask;
                var dataRelation = relationObj.dataRelation;
                var dataRelationField = relationObj.dataRelationField;
                var extraMap = relationObj.extraMap;
                assFormParams = _this.assDocFormBaseInfo(id,recodeID,isNew,contentDataID,toRelationObjType,toRelationObj,
                    toRelationAttrType,toRelationAttr,sysRelationForm,formRelation,formRelationField,fromRelationObj,
                    fromRelationAttr,formRelationFlow,viewAttr,viewSelectType,viewType,viewConditionId,dataRelationImageEnum,
                    dataRelationMember,dataRelationDepartment,dataRelationMultiEnum,dataRelationLbs,dataRelationMap,dataRelationProject,
                    dataExchangeTask,dataRelation,dataRelationField,extraMap);
                if(formType == MAssFormConstant.C_iMAssFormFormType_flowForm) {
                    requestAjax = MUtils.mRequestAjaxParams(
                        MAssFormService.C_sMAssFormServiceManagerName_mFormManager,
                        MAssFormService.C_sMAssFormServiceMethod_getFlowRelationFormBasicInfo,
                        assFormParams
                    );
                }else  {
                    requestAjax = MUtils.mRequestAjaxParams(
                        MAssFormService.C_sMAssFormServiceManagerName_mFormManager,
                        MAssFormService.C_sMAssFormServiceMethod_getNoFlowRelationFormBasicInfo,
                        assFormParams
                    );
                }
                MUtils.mRequestForAjax(MAssFormService.C_sMAssFormServiceBaseUrl,requestAjax,function (result){//获取表单基础信息（此信息还不能作渲染用）
                    var searchFieldList = result.searchFieldList;//提取用于搜索的关键字类型列表
                    toFormBean = $.parseJSON(result.toFormBean);//将关键属性缓存
                    var columnListHtmlStr = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_assFormColumnList);
                    var columnListHtml = MUtils.tpl(columnListHtmlStr,result);
                    var listDateRequestParams = result.listDateRequestParams;
                    var formId = result.formID;
                    var formTemplateId = result.formTemplateID;
                    var sortStr = result.sortStr;
                    columnListMap = result.columnList;//取出表头字段后缓存
                    var fromFormId = listDateRequestParams.fromFormId;
                    var fromRelationAttr = listDateRequestParams.fromRelationAttr;
                    var fromDataId = listDateRequestParams.fromDataId;
                    var fromRecordId = listDateRequestParams.fromRecordId;
                    var Number = 0;
                    var size = MAssFormConstant.C_iMAssFormPagingNum;
                    var assFormData = _this.assFormData(formId,formTemplateId,sortStr,fromFormId,fromRelationAttr,fromDataId,fromRecordId,Number,size);  //用于请求表单列表数据的参数
                    var searchParams = _this.searchParamData(formId,formTemplateId,sortStr,fromFormId,fromRecordId,fromDataId,fromRelationAttr,Number,size);//用于搜素表单的参数
                    searchParams.searchFieldList = searchFieldList;
                    var loadMoreFormDataAjax = MUtils.mRequestAjaxParams(
                        MAssFormService.C_sMAssFormServiceManagerName_mFormManager,
                        MAssFormService.C_sMAssFormServiceMethod_loadMoreFormData,
                        assFormData
                    );
                    MUtils.mRequestForAjax(MAssFormService.C_sMAssFormServiceBaseUrl,loadMoreFormDataAjax,function(returnValue) {//获取表单数据列表（此列表作渲染用）
                        accFormMainScroller = new iScroll('accFormMainScroller',{
                            bounce: false,//横向滚动条把此禁了
                            hScrollbar: false,
                            vScrollbar: false,
                            hScroll : true,
                            vScroll : false,
                            snap: false,
                            momentum: true,
                            lockDirection: false,
                            fixedScrollbar: false,
                            onScrollMove : function() {
                                $("#leftCheckboxArea").css("left",-this.x);
                                pullDownUI.css("left",-this.x);
                                clickDownUI.css("left",-this.x);
                            },
                            onScrollEnd : function() {
                                $("#leftCheckboxArea").css("left",-this.x);
                                pullDownUI.css("left",-this.x);
                                clickDownUI.css("left",-this.x);
                            }
                        });
                        _this.contentTitleArea.append(columnListHtml); //将表头插入
                        returnValue.map = columnListMap;//将表头对应的字段存入map
                        mainContentScroller = _this.createMainContentScroller("contentMainArea",returnValue,assFormData,_this.loadMoreAssFormData);
                        _this.setTransverseScrollerWidth(accFormMainScroller);
                        setTimeout(function(){
                            containerUI.addClass("accDocWidget_showState");
                            _this.bindFormSearchEvent(searchParams);
                            bindFormItemChooseEvent(mainContentScroller);
                            _this.bindWidgetCloseEvent();
                            _this.bindOkEvent(mainContentScroller);
                        },0);
                    });
                });

            }catch (e) {
                throw "the relation data format error";
            }

        },
        /*=======================================UI展现部分=================================================================*/
        /**
         * 创建内容区域的scroller
         * @param id:滚动区ID
         * @param data：渲染list的数据
         * @param assFormData：加载更多数据所需要的参数
         * @param clickDownCallback：点击加载更多回调函数
         * @returns {Window.iScroll}
         */
        createMainContentScroller : function(id,data,assFormData,clickDownCallback) {
            var _this = this;
            var container = $("#" + id);
            var winWidth = $(window).width();
            var winHeight = $(window).height();
            var headerHeight = $("header.headerArea").height();
            var fixedlyAreaHieght = $("div.fixedlyArea").height();
            var footerHeight = $("footer.footerArea").height();
            var containerHeight = winHeight - headerHeight - fixedlyAreaHieght - footerHeight;
            container.css("height",containerHeight);
            var $pullDown = getPullDownUI();
            var $clickDown = getClickDownUI();
            var $listData = $("<div class='list_data'></div>");
            var scrollArea = $(container.find("#" + id + "_scroller")[0]);
            var leftCheckBoxArea = $('<div class="leftCheckBoxArea" id="leftCheckboxArea"></div>');
            var formListHtmlStr = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_assFormFormList);
            var formListHtml = MUtils.tpl(formListHtmlStr,data);
            $listData.html(formListHtml);
            scrollArea.append($pullDown).append($listData).append($clickDown);
            var pullDownEl = scrollArea.find('.pullDown')[0];
            var pullDownE2 = scrollArea.find('.pullDown');
            var pullDownOffset = pullDownEl.offsetHeight;
            var pullUpE2 = scrollArea.find('.clickDown');
            pullDownE2.css("width",winWidth);
            pullUpE2.css("width",winWidth);
            pullDownUI = pullDownE2;
            clickDownUI = pullUpE2;
            clickDownUI.attr("isSearch",false); //将初始化的点击的是否是搜索置为false
            var scroller = new iScroll(id,{
                scrollbarClass: 'myScrollbar',
                bounce: true,
                useTransition: false,
                fixedScrollbar: false,
                hScroll : false,
                vScroll : true,
                topOffset : pullDownOffset,
                onRefresh : function() {
                    if (pullDownE2.hasClass('loading')) {
                        pullDownE2.removeClass('loading');
                        pullDownE2.find("p").show();
                        $(pullDownE2.find("p")).first()
                            .removeClass("change_text_height")
                            .text("下拉刷新");
                    }
                    else if (pullUpE2.hasClass('loading')) {
                        pullUpE2.find("p").show();
                        pullUpE2.find("span").hide();
                        $(pullUpE2.find("p")).first()
                            .removeClass("margin_t_25")
                            .addClass("margin_t_15")
                            .text("加载更多");
                    }
                },
                onScrollMove : function() {
                    if (this.y > 5 && !pullDownE2.hasClass('flip')) {
                        pullDownE2.addClass('flip');
                        $(pullDownE2.find("p")).first().text("松手开始更新");
                        this.minScrollY = 0;
                    } else if (this.y < 5 && pullDownE2.hasClass('flip')) {
                        pullDownE2.removeClass('flip');
                        $(pullDownE2.find("p")).first().text("下拉刷新");
                    }
                },
                onScrollEnd : function() {
                    if (container.height() <= (container.find(".list_data").height() + pullDownOffset)) {
                        pullUpE2.css("opacity", "1");
                        pullDownE2.css("left",this.x);
                        pullUpE2.unbind("click").bind("click", function () {
                            pullUpE2.find("p").hide();
                            pullUpE2.find("span").show();
                            $(pullUpE2.find("p")).first().removeClass("margin_t_15").addClass("margin_t_25").text("加载中").show();
                            if(clickDownCallback != null) {
                                if(typeof clickDownCallback != "function") {
                                    throw "this param must be function";
                                }else {
                                    clickDownCallback(assFormData,scroller);
                                }
                            }
                            scroller.refresh();
                        });
                    }
                    if (pullDownE2.hasClass('flip')) {
                        pullDownE2.removeClass('flip').addClass('loading');
                        pullDownE2.find("p").hide();
                        $(pullDownE2.find("p")).first().addClass("change_text_height").text("加载中").show();
                        scroller.refresh();

                    }
                }
            });
            pageCount_default ++;
            setRefreshDomShow(data,$(pullDownEl),$(pullUpE2),false);
            return scroller;
        },

        //设置横向滚动区的宽度
        setTransverseScrollerWidth : function(accFormMainScroller) {
            var _this = this;
            var columns = $(_this.accFormMainScroller).find("ul.title").children("li");
            var columnsSize = columns.length -1;//减1是把表头的第一个空的li减去
            var oneColumnWidth = $(columns[1]).width();  //将表头第二个li（就是有文字的）作为统一宽度，（宽度一致）
            var headerColumnWidth = $(columns[0]).width();
            var columnsWidth = columnsSize * oneColumnWidth + headerColumnWidth;
            _this.transversePage.css("width",columnsWidth);//将横向滚动的宽度重新设置
            accFormMainScroller.refresh();
        },
        //创建搜索界面
        createSearchUI : function() {
            var searchUiWidgetHtml = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_searchUiWidget);
            var $search = $(searchUiWidgetHtml);
            var winHeight = $(window).height();
            var headerHeight = $("header.headerArea").height();
            $search.css("height",winHeight - headerHeight);
            var searchContainerHeight = $("div.accDocWidget_searchContainer").height();
            $("div.accDocWidget_shieldLayer",$search).css("height",(winHeight - headerHeight - searchContainerHeight));
            return $search;
        },
        /*========================================================事件部分========================================================================*/
        /**
         * 加载更多表单列表(区分是默认列表还是搜索结果列表)
         * @param assFormData：默认列表的请求数据
         * @param scroller:滚动scroll
         */
        loadMoreAssFormData : function(assFormData,scroller) {
            var _this = this;
            var isSearch = clickDownUI.attr("isSearch"); //通过查询clickDownUI储存的值进行搜索参数的设置
            var pageCount = (isSearch == true) ? pageCount_search : pageCount_default;
            var loadMoreParam = {};
            if(isSearch == true || isSearch == "true") {
                var searchParam = $.parseJSON(clickDownUI.attr("searchParam"));
                loadMoreParam = searchParam;
                loadMoreParam.Number = pageCount * MAssFormConstant.C_iMAssFormPagingNum;
            }else {
                loadMoreParam = assFormData;
                loadMoreParam.Number = pageCount * MAssFormConstant.C_iMAssFormPagingNum;
            }
            var loadMoreFormDataAjax = MUtils.mRequestAjaxParams(
                MAssFormService.C_sMAssFormServiceManagerName_mFormManager,
                MAssFormService.C_sMAssFormServiceMethod_loadMoreFormData,
                loadMoreParam
            );
            MUtils.mRequestForAjax(MAssFormService.C_sMAssFormServiceBaseUrl,loadMoreFormDataAjax,function(returnValue) {
                returnValue.map = columnListMap;
                pageCount_default ++;
                var wrapper = $(scroller.wrapper);
                var listDataArea = $(wrapper.find("div.list_data"));
                var leftCheckBoxArea = listDataArea.find("div.leftCheckBoxArea");
                var checkboxItemHtmlStr = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_assFormCheckboxItem);
                var formItemHtmlStr = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_assFormItem);
                var checkboxItemHtml = MUtils.tpl(checkboxItemHtmlStr,returnValue);
                var formItemHtml = MUtils.tpl(formItemHtmlStr,returnValue);
                leftCheckBoxArea.append(checkboxItemHtml);
                listDataArea.append(formItemHtml);
                setRefreshDomShow(returnValue,pullDownUI,clickDownUI,false);
                bindFormItemChooseEvent(scroller);
                scroller.refresh();
            });
        },

        //搜索表单
        bindFormSearchEvent : function(searchParams) {
            var _this = this;
            _this.searchBtn.off("click").on("click",function() {
                _this.showSearchUI(searchParams);
            });
        },
        //关闭关联表单组件
        bindWidgetCloseEvent : function() {
            var _this = this;
            _this.closeBtn.unbind("click").bind("click",function() {
                if(MAssFormOptions.closeCallback){
                    MAssFormOptions.closeCallback();
                }
                _this.bindCloseEvent();
            });
        },
        //确定
        bindOkEvent : function(scroller) {
            var _this = this;
            _this.okBtn.unbind("click").bind("click",function() {
                var listContainer = $(scroller.wrapper);
                var radioBoxArea = listContainer.find("div.leftCheckBoxArea");
                var selectArray = []; //储存选择结果的数组
                var subData = [];//表单子对象储存数组
                var tempObj = {};
                var masterDataId = radioBoxArea.find(":checked").attr("id");
                if(masterDataId) {
                    tempObj.masterDataId = masterDataId;
                    var tableList = toFormBean.tableList;
                    for(var i = 0 ; i < tableList.length; i ++) {   //有可能这里的数据处理埋了一个坑
                        var tempTable = tableList[i];
                        if(tempTable.tableType.toLowerCase() == "slave") {
                            var tempSubData = {};
                            var tempSubArray = [];
                            tempSubData.tableName = tempTable.tableName;
                            tempSubArray.push(masterDataId);
                            tempSubData.dataIds = tempSubArray;
                            subData.push(tempSubData);
                        }
                    }
                    tempObj.subData = subData;
                    selectArray.push(tempObj);
                }
                var obj = new Object();
                obj.selectArray = selectArray;
                obj.toFormId = toFormBean.id;
                if(MAssFormOptions.okCallback) {
                    MAssFormOptions.okCallback($.toJSON(obj));
                }
                _this.bindCloseEvent();
            });
        },
        bindCloseEvent : function() {
            var _this = this;
            accFormMainScroller = null;
            mainContentScroller = null;
            searchTypeAreaScroller = null;
            pageCount_default = null;
            pageCount_search = null;
            toFormBean = null;
            MAssFormOptions = null;
            _this.widgetUI.remove();
            _this.widgetUI = null;

        },
        showSearchUI : function(searchParams) {
            var _this =this;
            var top  = _this.widgetUI.scrollTop();
            _this.searchWidget = _this.createSearchUI();
            _this.searchWidget.css("top",top).css("z-index",2003);
            _this.searchWidget.find("div.headerTitle").html('<span>搜素</span>');
            _this.searchWidget.appendTo(_this.widgetUI);
            var returnBtn = $(".headerCloseBtn2",_this.searchWidget);
            var titleArea = $(".titleArea",_this.searchWidget);
            var keywordTypeArea = $(".keywordTypeArea",_this.searchWidget);
            var list = $(".list",keywordTypeArea);
            list.attr("id","formSearch_scroller").css("height",MAssFormConstant.C_iMAssFormSearchKeywordTypeAreaHeight).css("bottom",0);
            list.html("<div class='scroller'></div>");
            var scrollArea = list.find("div.scroller");
            titleArea.find("div.title").html(searchParams.searchFieldList[0].display).attr("value", $.toJSON(searchParams.searchFieldList[0])).attr("inputType",searchParams.searchFieldList[0].inputType); //将搜索类型列表的第一个作为初始值
            var keywordTypeTplPath = MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_searchKeywordType;
            var tplStr = MUtils.readFileContent(keywordTypeTplPath);
            var html = MUtils.tpl(tplStr,searchParams);
            var keywordInputArea = keywordTypeArea.next("div.keywordInputArea");
            var inputType = searchParams.searchFieldList[0].inputType;
            _this.handleSearchTypeShow(keywordInputArea,inputType);
            titleArea.off("click").on("click",function() {
                    if(keywordTypeArea.hasClass("accDocWidget_searchContainer_hidden")) {
                        keywordTypeArea.removeClass("accDocWidget_searchContainer_hidden").addClass("accDocWidget_searchContainer_show");
                        titleArea.find("span").removeClass("cmp_downward").addClass("cmp_topward");
                        var backValue = titleArea.find("div.title").attr("value");
                        if(searchTypeAreaScroller == null) { //创建一个scroll区域
                            searchTypeAreaScroller = new iScroll('formSearch_scroller',{
                                scrollbarClass: 'myScrollbar',
                                bounce: false,
                                hScrollbar: false,
                                vScrollbar: false,
                                useTransition: false,
                                fixedScrollbar: false,
                                hScroll : false,
                                vScroll : true
                            });
                            scrollArea.html(html);
                            searchTypeAreaScroller.refresh();
                        }
                        _this.bindSearchTypeChooseEvent(scrollArea);
                    }else if(keywordTypeArea.hasClass("accDocWidget_searchContainer_show")){
                        titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
                        keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");
                    }
            });
            returnBtn.off("click").on("click",function() {
                _this.searchWidget.remove();
                _this.searchWidget = null;
                searchTypeAreaScroller = null;
            });
            keywordInputArea.off("click").on("click",function() {
                if(keywordTypeArea.hasClass("accDocWidget_searchContainer_show")){
                    titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
                    keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");
                }
            });
            _this.bindSearchActionEvent(_this.searchWidget,searchParams);

        },
        bindSearchTypeChooseEvent : function(scrollArea) {
            var _this = this;
            scrollArea.children("div.listItem").off("click").on("click",function() {
                var inputType = $(this).attr("inputType");
                var value = $(this).attr("value");
                var keywordTypeArea = $(this).parents("div.keywordTypeArea");
                var titleArea = keywordTypeArea.prev("div.titleArea");
                var keywordInputArea = keywordTypeArea.next("div.keywordInputArea");
                var keywordName = $(this).find("div.keywordName").html();
                titleArea.find("div.title").html(keywordName).attr("value",value).attr("inputType",inputType);
                titleArea.find("span").removeClass("cmp_topward").addClass("cmp_downward");
                _this.handleSearchTypeShow(keywordInputArea,inputType);
                keywordTypeArea.removeClass("accDocWidget_searchContainer_show").addClass("accDocWidget_searchContainer_hidden");

            });
        },
        /**
         * 处理搜索组件的输入域的显示
         * @param keywordInputArea:有搜索输入域的区域
         * @param inputType：搜索类型：（1、“m1-startdate”和“m1-modifydate”日期类型）
         *                            （2、“startmember”选人类型）
         *                            （3、“text”普通输入域）
         */
        handleSearchTypeShow : function(keywordInputArea,inputType) {
            var _this = this;
            if(inputType == "m1-startdate" || inputType == "m1-modifydate" || inputType == "date" || inputType =="datetime") {//如果是选的日期
                var dateUI = getDateUI();
                keywordInputArea.html(dateUI);
                var startDate = $(".startDate",keywordInputArea);
                var endDate = $(".endDate",keywordInputArea);
                _this.handleDateSearchMethod(startDate,endDate);//单独处理日期方式的搜索
            }else {
                keywordInputArea.html('<div class="inputBox"><input type="text" placeholder="请输入关键字" class="search" id="search"></div>');
                if(inputType == "m1-startmember" || inputType == "member" || inputType == "department" || inputType == "account" || inputType == "post" || inputType == "level"){//选人
                    _this.handleMemberSearchMethod(keywordInputArea,inputType);//对选人的类型进行单独处理
                }else if(inputType == "radio" || inputType == "checkbox" || inputType == "select") {//此三类控件统一处理（用select的方式展示）
                    _this.handleEnumSearchMethod(keywordInputArea,inputType);
                }else if(inputType == "project") {//关联项目

                }

            }
        },
        /**
         * 绑定搜索按钮事件
         * @param searchWidget:搜索组件
         * @param searchParams：搜索参数
         */
        bindSearchActionEvent : function(searchWidget,searchParams) {
            var _this = this;
            var searchBtn = searchWidget.find("div.searchActionArea").find("div.searchBtn");
            var title = searchWidget.find("div.titleArea").find("div.title");
            searchBtn.off("click").on("click",function() {
                var titleValue = title.attr("value");
                var inputType = title.attr("inputType");
                titleValue = $.parseJSON(titleValue);
                var keywordName = titleValue.name;
                var keywordInputs = searchWidget.find("div.keywordInputArea").find("input[type=text]");
                var dateKeywordArr = [];//用于“创建时间”和“修改时间”的开始时间和结束时间的数组
                var keywordParam = {};//用于查询的参数（各种组合结果）
                if(keywordInputs.length > 1) {//如果是日期选择
                    var startTime = keywordInputs[0].value;
                    var endTime = keywordInputs[1].value;
                    if(new Date(endTime.replace(/-/g, "//")) < new Date(startTime.replace(/-/g, "//"))){
                        $.alert("结束时间不能小于开始时间");
                        return ;
                    }
                    dateKeywordArr.push(startTime);
                    dateKeywordArr.push(endTime);
                    if(inputType == "m1-startdate") {//创建时间
                        keywordParam.start_date = dateKeywordArr;
                    }else  { //修改时间
                        keywordParam.modify_date = dateKeywordArr;
                    }
                }else {
                    if(inputType == "m1-startmember") { //如果是创建人
                        var memberIdKeyword = searchWidget.find("div.keywordInputArea").find("input[id=memberId]").val();
                        keywordParam.start_member_id = {
                            classType : 'MFormQueryCondition',
                            fieldName : keywordName,
                            fieldValue : memberIdKeyword,
                            operation : titleValue.queryOperatorList[0].operator
                        }
                    }else {//这个是inputType=text的情况
                        var keyword = ""
                        if(inputType == "member" || inputType == "department" || inputType == "post" || inputType == "level" || inputType == "account"){//选人的来取值
                            keyword = searchWidget.find("div.keywordInputArea").find("input[id=memberId]").val();
                        }else if(inputType == "") {

                        }else {//这个是inputType=text的（即普通输入域）
                            keyword = keywordInputs.val();
                        }
                        keywordParam[keywordName] = {
                            classType : "MFormQueryCondition",
                            fieldName : keywordName,
                            fieldValue : keyword,
                            operation : titleValue.queryOperatorList[0].operator
                        }
                    }
                }
                keywordParam.formId = searchParams.formId;
                keywordParam.formTemplateId = searchParams.formTemplateId;
                keywordParam.sortStr = searchParams.sortStr;
                keywordParam.fromFormId = searchParams.fromFormId;
                keywordParam.fromRelationAttr = searchParams.fromRelationAttr;
                keywordParam.fromDataId = searchParams.fromDataId;
                keywordParam.fromRecordId = searchParams.fromRecordId;
                keywordParam.Number = searchParams.Number;
                keywordParam.size = searchParams.size;
                _this.searchRelationFormData(keywordParam,inputType);
                searchWidget.remove();
                searchWidget = null;
                searchTypeAreaScroller = null;
            });
        },
        searchRelationFormData : function(keywordParam,inputType) {
          var _this = this;
          var searchRelationRequest = MUtils.mRequestAjaxParams(
              MAssFormService.C_sMAssFormServiceManagerName_mFormManager,
              MAssFormService.C_sMAssFormServiceMethod_loadMoreFormData,
              keywordParam
          );
          MUtils.mRequestForAjax(
              MAssFormService.C_sMAssFormServiceBaseUrl,
              searchRelationRequest,
              function(returnValue){
                  pageCount_search = 0;
                  returnValue.map = columnListMap;
                  var formListHtmlStr = MUtils.readFileContent(MAssFormOptions.serverURL + MAssFormConstant.C_sMAssFormTplPath_assFormFormList);
                  var formListHtml = MUtils.tpl(formListHtmlStr,returnValue);
                  var mainContentWrapper = $(mainContentScroller.wrapper);
                  var listData = mainContentWrapper.find("div.list_data");
                  clickDownUI.attr("isSearch",true).attr("searchParam", $.toJSON(keywordParam));//将搜索的各种属性设置到点击更多按钮上
                  listData.html(formListHtml);
                  mainContentWrapper.css("bottom",0);//调整纵向滚动区到初始位置
                  accFormMainScroller.scrollTo(0,0);//调整横向滚动区到初始位置
                  pageCount_search ++;
                  setRefreshDomShow(returnValue,pullDownUI,clickDownUI,true);
                  bindFormItemChooseEvent(mainContentScroller);
              }
          );

        },
        //处理人员类型的选择（需要弹出选人组件）
        handleMemberSearchMethod : function(inputArea,inputType) {
            var _this = this;
            var memberInputBox = inputArea.find("div.inputBox");
            memberInputBox.append("<input type='hidden' class='memberId' id='memberId'>");
            var memberTextInput = memberInputBox.find("input[id=search]");
            var memberValInput = memberInputBox.find("input[id=memberId]");
            var choosePanel = null;
            memberTextInput.$click(function() {
                switch (inputType) {
                    case "m1-startmember":
                    case "member" :
                        choosePanel = new CMPChoosePerson($("body"),{
                            maxSize : 1,
                            radio : true,
                            basePath : MAssFormOptions.serverURL + "/",
                            serverURL : MAssFormOptions.serverURL + "/",
                            currentAccountID : MAssFormOptions.currentAccountID,
                            callback : function(data) {
                                var id = "";
                                var name = "";
                                if(data && data.length > 0) {
                                    for(var i = 0 ; i < data.length ; i ++) {
                                        var tempObj = data[i];
                                        id = tempObj.memberID;
                                        name = tempObj.name;
                                    }
                                }
                                memberTextInput.val(name);
                                memberValInput.val(id);
                                choosePanel.close();
                                choosePanel = null;
                            }

                        });
                        break;
                    case "department" :
                        choosePanel = new CMPChooseDept($("body"),{
                            maxSize : 1,
                            radio : true,
                            basePath : MAssFormOptions.serverURL + "/",
                            serverURL : MAssFormOptions.serverURL + "/",
                            currentAccountID : MAssFormOptions.currentAccountID,
                            callback : function(data) {
                                var id = "";
                                var name = "";
                                if(data && data.length > 0) {
                                    for(var i = 0 ; i < data.length ; i ++) {
                                        var tempObj = data[i];
                                        id = tempObj.unitID;
                                        name = tempObj.name;
                                    }
                                }
                                memberTextInput.val(name);
                                memberValInput.val(id);
                                choosePanel.close();
                                choosePanel = null;
                            }
                        });
                        break;
                    case "post" :
                        choosePanel = new CMPChoosePost($("body"),{
                            maxSize : 1,
                            radio : true,
                            basePath : MAssFormOptions.serverURL + "/",
                            serverURL : MAssFormOptions.serverURL + "/",
                            currentAccountID : MAssFormOptions.currentAccountID,
                            callback : function(data) {
                                var id = "";
                                var name = "";
                                if(data && data.length > 0) {
                                    for(var i = 0 ; i < data.length ; i ++) {
                                        var tempObj = data[i];
                                        id = tempObj.postID;
                                        name = tempObj.name;
                                    }
                                }
                                memberTextInput.val(name);
                                memberValInput.val(id);
                                choosePanel.close();
                                choosePanel = null;
                            }
                        });
                        break;
                    case "level" :
                        choosePanel = new CMPChooseLevel($("body"),{
                            maxSize : 1,
                            radio : true,
                            basePath : MAssFormOptions.serverURL + "/",
                            serverURL : MAssFormOptions.serverURL + "/",
                            currentAccountID : MAssFormOptions.currentAccountID,
                            callback : function(data) {
                                var id = "";
                                var name = "";
                                if(data && data.length > 0) {
                                    for(var i = 0 ; i < data.length ; i ++) {
                                        var tempObj = data[i];
                                        id = tempObj.levelID;
                                        name = tempObj.name;
                                    }
                                }
                                memberTextInput.val(name);
                                memberValInput.val(id);
                                choosePanel.close();
                                choosePanel = null;
                            }
                        });
                        break;
                    case "account" :
                        //TODO 选单位的组件
                        break;
                }

            });
        },

        //处理日期类型的选择(需要弹出日历组件)
        handleDateSearchMethod : function(startDateInput,endDateInput) {
            var startCalendar = null;
            var endCalendar = null
            var nowDate = new Date();
            var year = nowDate.getFullYear();
            var month = nowDate.getMonth() +1;
            var date = nowDate.getDate();
            month = month < 10 ?"0" + month : month;
            date = date < 10 ? "0" + date : date;
            var formatDate = year + "-" + month + "-" + date;
            startDateInput.val(formatDate);
            endDateInput.val(formatDate);
            startDateInput.addClass("dateInputActive").addClass("initAction");
            var startDateOptions = {
                okCallback : function(formatDate){
                    startDateInput.val(formatDate);
                    if(startDateInput.hasClass('initAction')) startDateInput.removeClass("initAction");
                    startCalendar = null;
                },
                clearCallback : function() {
                    startDateInput.val("");
                    if(startDateInput.hasClass('initAction')) startDateInput.removeClass("initAction");
                    startCalendar = null;
                }
            }
            var endDateOptions = {
                okCallback : function(formatDate){
                    endDateInput.val(formatDate);
                    endCalendar = null;
                },
                clearCallback : function() {
                    endDateInput.val("");
                    endCalendar = null;
                }
            }
            if(startDateInput.hasClass("initAction")) {
                startCalendar = new MCalendar(startDateInput,startDateOptions);
                startCalendar.showDateWidget();
            }
            startDateInput.$click(function() {
                if(endDateInput.hasClass("dateInputActive")){
                    endDateInput.removeClass("dateInputActive");
                    startDateInput.addClass("dateInputActive");
                }
                startCalendar = new MCalendar(startDateInput,startDateOptions);
                startCalendar.showDateWidget();
            });

            endDateInput.$click(function() {
                if(startDateInput.hasClass("dateInputActive")){
                    startDateInput.removeClass("dateInputActive");
                    endDateInput.addClass("dateInputActive");
                }
                endCalendar = new MCalendar(endDateInput,endDateOptions);
                endCalendar.showDateWidget();
            });
        },
        //处理有枚举的搜索
        handleEnumSearchMethod : function(inputArea,inputType){
            var enumInputBox = inputArea.find("div.inputBox");
            enumInputBox.append("<input type='hidden' class='enumId' id='enumId'>");
            var enumTextInput = enumInputBox.find("input[id=search]");
            var enumValInput = enumInputBox.find("input[id=enumId]");

        },
        /*=========================================================数据处理部分==================================================================*/
        //关联表单基础信息(完全匹配服务器端的接口)
        assDocFormBaseInfo : function (id,recordID,isNew,contentDataId,toRelationObjType,toRelationObj,toRelationAttrType,toRelationAttr,
                                       sysRelationForm,formRelation,formRelationField,fromRelationObj,fromRelationAttr,formRelationFlow,
                                       viewAttr,viewSelectType,viewType,viewConditionId,dataRelationImageEnum,dataRelationMember,dataRelationDepartment,
                                       dataRelationMultiEnum,dataRelationLbs,dataRelationMap,dataRelationProject,dataExchangeTask,dataRelation,
                                       dataRelationField,extraMap){
            var assForm = new Object();
            assForm.id = id;
            assForm.recordID = recordID;
            assForm.new = isNew;
            assForm.contentDataId = contentDataId;
            assForm.toRelationObjType = toRelationObjType;
            assForm.toRelationObj = toRelationObj;
            assForm.toRelationAttrType = toRelationAttrType;
            assForm.toRelationAttr = toRelationAttr;
            assForm.sysRelationForm = sysRelationForm;
            assForm.formRelation = formRelation;
            assForm.formRelationField = formRelationField;
            assForm.fromRelationObj = fromRelationObj;
            assForm.fromRelationAttr = fromRelationAttr;
            assForm.formRelationFlow = formRelationFlow;
            assForm.viewAttr = viewAttr;
            assForm.viewSelectType = viewSelectType;
            assForm.viewType = viewType;
            assForm.viewConditionId = viewConditionId;
            assForm.dataRelationImageEnum = dataRelationImageEnum;
            assForm.dataRelationMember = dataRelationMember;
            assForm.dataRelationDepartment = dataRelationDepartment;
            assForm.dataRelationMultiEnum = dataRelationMultiEnum;
            assForm.dataRelationLbs = dataRelationLbs;
            assForm.dataRelationMap = dataRelationMap;
            assForm.dataRelationProject = dataRelationProject;
            assForm.dataExchangeTask = dataExchangeTask;
            assForm.dataRelation = dataRelation
            assForm.dataRelationField = dataRelationField;
            assForm.extraMap = extraMap;
            return assForm;
        },
        //关联表单数据列表
        assFormData : function (formId,formTemplateId,sortStr,fromFormId,fromRelationAttr,fromDataId,fromRecordId,Number,size){
            var assFormData = new Object();
            assFormData.formId = formId;
            assFormData.formTemplateId = formTemplateId;
            assFormData.sortStr = sortStr;
            assFormData.fromFormId = fromFormId;
            assFormData.fromRelationAttr = fromRelationAttr;
            assFormData.fromDataId = fromDataId;
            assFormData.fromRecordId = fromRecordId;
            assFormData.Number = Number;
            assFormData.size = size;
            return assFormData;
        },
        //搜索参数
        searchParamData : function(formId,formTemplateId,sortStr,fromFormId,fromRecordId,fromDataId,fromRelationAttr,Number,size) {
            var searchParamData = new Object();
            searchParamData.formId = formId;
            searchParamData.formTemplateId = formTemplateId;
            searchParamData.sortStr = sortStr;
            searchParamData.fromFormId = fromFormId;
            searchParamData.fromRecordId = fromRecordId;
            searchParamData.fromDataId = fromDataId;
            searchParamData.fromRelationAttr = fromRelationAttr;
            searchParamData.Number = Number;
            searchParamData.size = size;
            return searchParamData;
        }

    }
/*==============================组装ui的html部分=============================================================================*/
    //组件ui
    function getListUI() {
        var uiHtml = '<div class="accDocWidget accDocWidget_hiddenState accDocWidget_assFormWidget">' +
            '   <header class="headerArea" style="z-index: 2002;position: relative;">' +
            '       <div class="headerCloseBtn"><span class="accDocWidget_uiClose"></span></div>' +
            '       <div class="headerTitle">选择关联表单</div>'+
            '       <div class="headerSearch"><span class="cmp_btn4Search"></span></div>'+
            '   </header>' +
            '   <div class="fixedlyArea"></div>'+
            '   <div id="accFormMainScroller" class="assFormMaincontentArea">' +
            '       <div id="transversePage">' +
            '           <div class="scrollerwrapper" id="contentTitleArea"></div>' +
            '           <div class="scrollerwrapper" id="contentMainArea">' +
            '               <div class="scroller" id="contentMainArea_scroller"></div>' +
            '           </div>'+
            '       </div>' +
            '   </div>'+
            '   <footer class="footerArea" style="z-index: 2002;">' +
            '       <div class="okBtn">确定</div>' +
            '   </footer>'+
            '</div>';
        return $(uiHtml);
    }
    //上拉下拉ui
    function getPullDownUI() {
        var pullDownHtml = '<div class="pullDown">' +
            '<span class="pullDownIcon"></span>' +
            '<div class="pullDownText">' +
            '<p id="cmp_textForPullDown">下拉刷新</p>' +
            '<p id="cmp_textForPullDownListNumSum"></p>' +
            '<p id="cmp_textForPullDownListTime"></p>' +
            '</div>' +
            '</div>';
        return $(pullDownHtml);
    }
    //点击加载更多UI
    function getClickDownUI() {
        var clickDownHtml = '<div class="clickDown loading">' +
            '<p style="margin-top: 15px;"  id="cmp_textForClickDownLoadMore">加载更多</p>' +
            '<p style="margin-top: 5px;"  id="cmp_textForClickDownListNum"></p>' +
            '<span class="pullDownIcon"></span>' +
            '</div>';
        return $(clickDownHtml);
    }
    //日期输入UI
    function getDateUI() {
        var linkageDateUIHtml = '<div class="dateUiArea">' +
            '   <div class="dateInputBox"><input type="text" class="startDate" id="startDate"></div>' +
            '   <div class="dateInputBoxLink"><span>至</span></div>'+
            '   <div class="dateInputBox"><input type="text" class="endDate" id="endDate"></div>' +
            '</div>';
        return linkageDateUIHtml;
    }
    //上拉下拉文字的刷新
    var setRefreshDomShow = function(data,pullDownUI,clickDownUI,isSearchMethod) {
        var total = data.total;
        var refreshDate = new Date().format("yyyy-MM-dd hh:mm:ss");
        var pageCount = (isSearchMethod)?pageCount_search : pageCount_default;
        var dataLeaveNum = ((total - pageCount * MAssFormConstant.C_iMAssFormPagingNum) <= 0)? 0 : (total - pageCount * MAssFormConstant.C_iMAssFormPagingNum);
        pullDownUI.find("#cmp_textForPullDownListNumSum").html("共"+total+"条");
        pullDownUI.find("#cmp_textForPullDownListTime").html("最近更新："+refreshDate+"");
        if(dataLeaveNum <= 0) {
            clickDownUI.hide();
        }else {
            clickDownUI.show();
            clickDownUI.find("#cmp_textForClickDownListNum").html("还有"+dataLeaveNum+"条");

        }
    }
    //选择表单（单选）
    var bindFormItemChooseEvent = function(scroller) {
        var listContainer = $(scroller.wrapper);
        var radioBoxArea = listContainer.find("div.leftCheckBoxArea");
        var radioBoxs = radioBoxArea.find("span.accDocWidget_checkbox");
        radioBoxs.each(function() {
            var radio = $(this).find("input[type=radio]");
            $(this).unbind("click").bind("click",function() {
                if(radio[0].checked == false){
                    radioBoxArea.find(":checked").checked = false;
                    radio[0].checked = true;
                }
            });
        });

        var formListUls = listContainer.find("ul");
        formListUls.each(function() {
            $(this).unbind("click").bind("click",function() {
                var id = $(this).attr("id");
                id = id.replace("form_","");
                radioBoxs.find("input[type=radio]").each(function() {
                    if($(this).attr("id") == id) {
                        if($(this)[0].checked == false){
                            radioBoxArea.find(":checked").checked = false;
                            $(this)[0].checked = true;
                        }
                    }
                });
                return false;
            });
        });
    }

    return MAssForm;
})();
//MAssForm.js e
//form_selectOrg.js s
/**
 * Created by Administrator on 2014-12-25.
 */
var form_selectOrg = (function() {
    function form_selectOrg(tj,isMulti) {
        var _this = this;
        _this.dom = tj;
        _this.maxSize = tj.maxSize;
        _this.isMulti = isMulti;
        _this.radio = (tj.maxSize == 1) ? true : false;
    }
    MFormSelectOrgConstant = {
        C_iSelectOrgType_selectMember : 1,
        C_iSelectOrgType_selectDepartment : 2,
        C_iSelectOrgType_selectPost : 3,
        C_iSelectOrgType_selectLevel : 5
    }
    MFormSelectOrgService = {
        C_sMFormSelectOrgServiceBaseUrl : "http://" + document.location.host + "/seeyon/ajax.do?method=ajaxAction",
        C_sMFormSelectOrgServiceManagerName: "formManager",
        C_sMFormSelectOrgServiceMethod_dealOrgFieldRelation : "dealOrgFieldRelation"
    }

    var createValueObj = function(ids,names) {
        var valObj ={};
        valObj.ids = ids;
        valObj.names = names;
        return valObj;
    };

    form_selectOrg.prototype = {
        selectOrg : function() {
            var _this = this;
            var dom = _this.dom;
            var ctrlID = dom.srcElement.attr("id");
            var value = dom.value;
            var fillbackSaveValue;
            var fillbackDisplayValue;
            var choosePanel;
            var displayValueCtrl = $(dom.srcElement);
            var hiddenCtrlID = ctrlID.replace("_txt","");
            var returnValueCtrl = displayValueCtrl.next("input[id="+hiddenCtrlID+"]");
            var valObj = "";
            if((returnValueCtrl.val().length == 0 && returnValueCtrl.val() == "") && (typeof value != "undefined" && value.length >0)) {
                fillbackSaveValue = value;
            }else {
                fillbackSaveValue = returnValueCtrl.val();
            }

            fillbackDisplayValue = displayValueCtrl.val();

            if(fillbackSaveValue != "" && fillbackSaveValue.length > 0) {
                valObj = new createValueObj(fillbackSaveValue,fillbackDisplayValue);
            }
            selectOrgPreCallBack(dom);//选人在选之前要调该表单组的接口


            switch (dom.selectType) {
                case  "Member" :
                    choosePanel = new CMPChoosePerson($("body"),{
                        maxSize : _this.maxSize,
                        radio : _this.radio,
                        basePath : MFormConfig.serverURL + "/",
                        serverURL : MFormConfig.serverURL + "/",
                        currentAccountID : MChooseConfig.currentAccountID,
                        callback : function(data) {
                            _this.selectOrgCallbackFun(data,1,returnValueCtrl,displayValueCtrl);
                            choosePanel.close();
                            choosePanel = null;
                        },
                        fillBackData : valObj
                    });
                    break;
                case "Department" :
                    choosePanel = new CMPChooseDept($("body"),{
                        maxSize : _this.maxSize,
                        basePath : MFormConfig.serverURL + "/",
                        serverURL : MFormConfig.serverURL + "/",
                        currentAccountID : MChooseConfig.currentAccountID,
                        callback : function(data) {
                            _this.selectOrgCallbackFun(data,2,returnValueCtrl,displayValueCtrl);
                            choosePanel.close();
                            choosePanel = null;
                        },
                        fillBackData : valObj
                    });
                    break;
                case "Post" :
                    choosePanel = new CMPChoosePost($("body"),{
                        maxSize : _this.maxSize,
                        basePath : MFormConfig.serverURL + "/",
                        serverURL : MFormConfig.serverURL + "/",
                        currentAccountID : MChooseConfig.currentAccountID,
                        callback : function(data) {
                            _this.selectOrgCallbackFun(data,3,returnValueCtrl,displayValueCtrl);
                            choosePanel.close();
                            choosePanel = null;
                        },
                        fillBackData : valObj
                    });
                    break;
                case "Level" :
                    choosePanel = new CMPChooseLevel($("body"),{
                        maxSize : _this.maxSize,
                        basePath : MFormConfig.serverURL + "/",
                        serverURL : MFormConfig.serverURL + "/",
                        currentAccountID : MChooseConfig.currentAccountID,
                        callback : function(data) {
                            _this.selectOrgCallbackFun(data,5,returnValueCtrl,displayValueCtrl);
                            choosePanel.close();
                            choosePanel = null;
                        },
                        fillBackData : valObj
                    });
                    break;
                default :
                    break;
            }
        },
        selectOrgCallbackFun : function(data,selectType,returnValueCtrl,displayValueCtrl) {
            var _this = this;
            var returnValue = "";
            var displayValue = "";
            if(data && data.length > 0) {
                var checkCallbackValueMap = _this.selectOrgCallBackValueMap(data,selectType);
                returnValue = checkCallbackValueMap.get("returnValue");
                displayValue = checkCallbackValueMap.get("displayValue");
            }else if(data.length == 0) {
                returnValue = "";
                displayValue = "";
            }
            returnValueCtrl.val(returnValue);
            if(_this.isMulti) {
                displayValueCtrl.text(displayValue);

            }else {
                displayValueCtrl.val(displayValue);
            }
            var oldVal = returnValueCtrl.attr("oldVal");
            if(oldVal == returnValue) {  //做优化处理，如果当前的选择值与oldVal的值相等则直接返回，不做数据关联和属性的设置
                return;
            }else {
                if(_this.dom.hasRelationField == true || typeof _this.dom.hasRelationField == "true") {  //做数据关联处理
                    if(form == undefined || typeof form == "undefined" || form == null) {
                        //doNoting
                    }else {
                        _this.handleRelationMemberData(data,_this.dom,selectType,checkCallbackValueMap); //处理选人的数据关联
                    }
                }

                displayValueCtrl.attr("title",displayValue);
                var comp = displayValueCtrl.attr("comp");
                var compObj = $.parseJSON("{"+comp+"}");
                compObj.value = returnValue;
                compObj.text = displayValue;
                var compJson = $.toJSON(compObj);
                var newComp = compJson.replace("{","").replace("}","");
                displayValueCtrl.attr("comp","").attr("comp",newComp);
                returnValueCtrl.attr("oldVal",returnValue);
            }
        },
        selectOrgCallBackValueMap : function(data,selectType) {
            var _this = this;
            var len = 0;
            var valueMap = new MMap();
            var returnValue = "";
            var displayValue = "";
            var MemberPrefix = "Member|";
            var DepartmentPrefix = "Department|";
            var PostPrefix = "Post|";
            var LevelPrefix = "Level|";
            if(data && data.length > 0) {
                len = data.length;
                for(var i = 0 ; i < len; i ++) {
                    var temObj = data[i];
                    var id;
                    var name;
                    if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectMember) {
                        id = MemberPrefix + temObj.memberID;
                        name = temObj.name;
                    }else if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectDepartment) {
                        id = DepartmentPrefix + temObj.unitID;
                        name = temObj.name;
                    }else if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectPost) {
                        id = PostPrefix + temObj.postID;
                        name = temObj.name;
                    }else if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectLevel) {
                        id =LevelPrefix + temObj.levelID;
                        name = temObj.name;
                    }
                    returnValue += id + ",";
                    displayValue += name + "、";
                }
            }
            if(returnValue != "" && displayValue != "") {
                returnValue = returnValue.substring(0, returnValue.length - 1);
                displayValue = displayValue.substring(0, displayValue.length - 1);
            }
            valueMap.put("returnValue",returnValue);
            valueMap.put("displayValue",displayValue);

            return valueMap;

        },
        /**
         * 处理选人的关联数据
         * @param data：选人选择好后的数据
         * @param options:comp值
         * @param selectType:判断选人组件的类型（用于简单快捷的适配表单组的数据结构）
         * @param valueMap:保存处理好了的选人数据的map
         */
        handleRelationMemberData : function(data,options,selectType,valueMap) {
            var toHandleData = {};
            var obj = new Array();
            var element = {};
            if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectMember) {
                element.id = data[0].memberID;
                element.type = "Member";
            }else if(selectType == MFormSelectOrgConstant.C_iSelectOrgType_selectDepartment) {
                element.id = data[0].unitID;
                element.type = "Department";
            }else if(selectType == -1) {  //初始化默认值的回填
                element.id = valueMap.get("returnValue").split("|")[1];
                element.type = valueMap.get("returnValue").split("|")[0];
            }
            element.name = valueMap.get("displayValue");
            obj.push(element);
            toHandleData.value = valueMap.get("returnValue");
            toHandleData.text = valueMap.get("displayValue");
            toHandleData.obj = obj;
            selectOrgCallBack(toHandleData,options);
            calculating = false;
        }
    }
    return form_selectOrg;
})();
//form_selectOrg.js e
//form_appendsText.js s
/**
 * Created by Administrator on 2015-3-2.
 */
var form_appendsText = (function () {

    function form_appendsText(targetObj, options) {
        var _this = this;
        _this.options = $.extend(true, {
            maxLength: undefined  //输入域字符数（默认未定义，则表示是大文本域）
        }, options)
        _this.dom = targetObj;
        var ctrl = _this.dom;

    }

    form_appendsText.prototype = {
        showAppendsTextWidget : function() {
            var _this = this;
            if (_this.options.maxLength) {  //如果定义了maxLength
                var valueLength = targetDomStrLength(_this.dom);
                _this.maxLength = (valueLength == 0) ? _this.options.maxLength : (_this.options.maxLength - valueLength);
                if (valueLength > _this.options.maxLength - 3) {
                    if (!$("body").find(".topTips").length > 0) {
                        displayTipsFromTop($.i18n.prop('cmp.form.appendsText.PopUpBox.tips.cantAppend'));
                    }
                    return;
                } else {
                    _this.bindAppendsTextEvent();
                }
            } else {
                _this.bindAppendsTextEvent();
            }
        },

        bindAppendsTextEvent: function () {
            var _this = this;
            _this.showInputBox();
        },
        /*==============UI部分=========================================*/
        renderInputBox: function () {
            var _this = this;
            var options = _this.options;
            var maxLength = options.maxLength;
            var inputBox = $('<div class="appendsTextWidget">' +
                '<div class="header">' +
                '<div class="titleArea">' +
                '<div class="closeBtn"><span class="cmpPhone32 cmp_close_32"></span></div>' +
                '<div class="title">' + $.i18n.prop("cmp.form.appendsText.PopUpBox.title") + '</div>' +
                '<div class="doneBtn">' + $.i18n.prop("cmp.form.appendsText.PopUpBox.doneBtn") + '</div>' +
                '</div>' +
                '</div>' +
                '<div class="content">' +
                '<div class="inputField">' +
                '<div class="inputDiv"><textarea placeholder="' + $.i18n.prop("cmp.form.appendsText.PopUpBox.inputField.tips") + '"></textarea></div>' +
                '</div>' +
                '</div>' +
                '</div>');
            var height = $(window).height();
            var position = $(document).scrollTop();
            inputBox.css("height", height).css("top", position);
            _this.closeBtn = $(".closeBtn", inputBox);
            _this.doneBtn = $(".doneBtn", inputBox);
            var content = $(".content", inputBox);
            _this.textarea = content.find("textarea");
            if (maxLength) {
                var inputField = $(".inputField", inputBox);
                var inputDiv = $(".inputDiv", inputBox);
                var charactersLimitDiv = $('<div class="charactersLimitDiv">' + _this.maxLength + '</div>');
                inputDiv.css("height", "90%");
                inputField.append(charactersLimitDiv);
                _this.charactersLimitDiv = $(".charactersLimitDiv", inputBox);
            }
            _this.inputBox = inputBox;
            return inputBox;
        },

        showInputBox: function () {
            var _this = this;
            var inputBox = _this.renderInputBox();
            inputBox.appendTo(document.body);
            inputBox.addClass("appendTextWidgetAnimationOpen");
            _this.bindInputEvent();
            _this.bindCloseEvent();
            _this.bindDoneEvent();

        },
        disappearInputBox: function () {
            var _this = this;
            var inputBox = _this.inputBox;
            inputBox.removeClass("appendTextWidgetAnimationOpen").addClass("appendTextWidgetAnimationClose");
            inputBox.remove();
        },
        /*=====================事件部分===========================*/
        bindInputEvent: function () {
            var _this = this;
            var options = _this.options;
            var format = options.format;
            var maxLength = _this.maxLength;
            var textArea = _this.textarea;
            textArea.focus();
            textArea.unbind("input").bind("input", function () {
                if (_this.options.maxLength) {
                    countStrByte($(this), _this.charactersLimitDiv, _this.maxLength);
                }
            });

        },
        bindCloseEvent: function () {
            var _this = this;
            var closeBtn = _this.closeBtn;
            closeBtn.unbind("click").bind("click", function () {
                _this.disappearInputBox();
            });
        },
        bindDoneEvent: function () {
            var _this = this;
            var textArea = _this.textarea;
            var doneBtn = _this.doneBtn;
            var dom = _this.dom;
            var domOldValue = dom.val();
            doneBtn.bind("click", function () {
                var value = textArea.val();
                _this.disappearInputBox();
                var addValue = assembleResultValue(value);
                var resultValue = (domOldValue.length == 0 || domOldValue == "") ? addValue : domOldValue + "\n" + addValue;
                dom.val(resultValue);
            });
        }
    }
    /*====================utils=================================*/
    var countStrByte = function (inputDom, displayDom, defaultStrLength) {  //对输入的字的个数进行控制
        var lastCount = 0;
        var byteCount = 0;
        var strValue = inputDom.val();
        var strValueLength = strValue ? strValue.length : 0;
        if (lastCount != strValueLength) {
            for (var i = 0; i < strValueLength; i++) {
                byteCount = (strValue.charCodeAt(i) <= 256) ? byteCount + 1 : byteCount + 3;
                if (byteCount > defaultStrLength) {
                    inputDom.val(strValue.substring(0, i));
                    if (!$("body").find(".topTips").length > 0) {
                        displayTipsFromTop($.i18n.prop("cmp.form.appendsText.PopUpBox.tips.mostCanInput", defaultStrLength));
                    }
                    byteCount = defaultStrLength;
                    break;
                }
            }
            lastCount = byteCount;
        }
        displayDom.text(defaultStrLength - lastCount);
    }
    var displayTipsFromTop = function (message) {  //弹出的提示框
        var tipsDiv = $('<div class="topTips">' +
            '<div class="content">' +
            '<span class="title">' + message + '</span>' +
            '</div>' +
            '</div>');
        var content = $(".content", tipsDiv);
        var closeBtn = $(".btn", tipsDiv);
        var hidePosition = $(document).scrollTop() - 50;
        var showPosition = hidePosition + 50;
        tipsDiv.css("top", hidePosition);
        var el = $("<div>");
        el.appendTo(document.body);
        el.append(tipsDiv);
        tipsDiv.animate({
            top: showPosition + "px"
        });
        closeBtn.bind("click", function () {
            tipsDiv.animate({
                top: hidePosition + "px"
            });
            tipsDiv.remove();
        });
        if ($("body").find(".topTips").length > 0) {
            setTimeout(function () {
                tipsDiv.animate({
                    top: hidePosition + "px"
                });
                tipsDiv.remove();
            }, 2000);
        }
    }
    /**
     * 获取目标输入域的字符个数
     * @param targetDom
     * @returns {Number}
     */
    var targetDomStrLength = function (targetDom) {
        var domValue = targetDom.val();
        var chineseRegex = /[^\x00-\xff]/g;
        return domValue.replace(chineseRegex, "***").length;
    }

    /**
     * 组装返回值；格式为：xxx[username yyyy-MM-dd mm:hh]
     * @param value
     * @returns {string}
     */
    var assembleResultValue = function (value) {
        var currentUser = MFormConfig.currentUser;

        return value + "[" + currentUser + " " + new Date().format('yyyy-MM-dd hh:mm') + "]";
    }

    return form_appendsText;
})();
//form_appendsText.js e
//form_uploadFile.js s
/**
 * Created by Administrator on 2014-12-30.
 */
var form_uploadFile = (function() {

    function form_uploadFile(tj,options) {
        var _this = this;
        _this.options = $.extend(true, {
            displayWidth: 112,//回显图片时的宽度
            displayHeight: 112,//回显图片时的高度
            loadingCallback : undefined,//文件上传前的回调
            loadedCallback : undefined,//处理附件数据的回调函数
            failedCallback : undefined,//文件上传失败的回调
            delCallback : undefined,//删除文件的回调
            backfillCallback : undefined,//回填数据的回调
            ctrl : '',//点击的控件
            fileInput : '',//用于选择文件的file控件
            isImageWidget : true,
            attsdata : undefined
        }, options);
        _this.compDiv = $(tj.srcElement);  //获取comp DIV
        _this.compContainer  = _this.compDiv.parent();    //图片/文件显示的大容器
        _this.fileInput = _this.options.fileInput;
        if(!_this.compContainer || _this.compContainer.length ==0) {
            throw "please defined file displayArea";
        }

        _this.compContainer.css("height","auto");//将容器的高度设置成auto，用于后续图片显示时的高度自动变化

        _this.downloadFileFram = $('<div style="display: none;height: auto">' +
                '<iframe name="downloadFileFrame" id="downloadFileFrame" frameborder="0" width="0" height="0"></iframe>' +
            '</div>');  //附件下载的返回区域
        _this.uploadingShieldLayer = MFormCompRenderBridge.commonWidget(1,"cmpPhone48 cmp_loading_48",null,"上传中...");
        if(tj.embedInput) {
            _this.compDiv.append('<input type="text"  id="'+(tj.embedInput ? tj.embedInput : '')+'" ' +
                'name="'+(tj.embedInput ? tj.embedInput : '')+'" value="" style="display:none;">');
        }

        if(_this.options.isImageWidget) { //如果是图片
        	_this.imgArea = $('<div style="float:right;width:85%;" id="attachmentArea'+tj.attachmentTrId+'"></div>');  //图片文件包含有图片的区域，是回填的时候的查询
            _this.compContainer.append(_this.imgArea);
        }else {
        	_this.attUlArea = $('<ul style="float:right;width:83%;" class="insertPic_displayAttUl padding_lr_10 padding_tb_5"  id="attachmentArea'+tj.attachmentTrId+'"></ul>'); //附件列表的区域，是回填的时候查询
            _this.compContainer.append(_this.attUlArea);
        }
//        _this.compContainer.append(_this.downloadFileFram);

        if(_this.options.attsdata && MUtils.judgeObjNotNull(_this.options.attsdata)) {  //如果是回填表单
            var backfillCallback = _this.options.backfillCallback;
            if(backfillCallback) {
                var callback = new Function(backfillCallback + '('+_this.options.attsdata+')');
                callback();
            }else {
                _this.parseBackfillFile(tj,_this.options.attsdata);
            }
        }

    }


    form_uploadFile.prototype = {
        /**
         * 判断上传附件的数量
         * @returns {boolean}
         */
        checkFile : function(tj) {
            var _this = this;
            var imageNum = 0;
            var attNum = 0;

            _this.fileForm = null;
            if(_this.options.isImageWidget) {
                imageNum = _this.imgArea.find("img").length;
            }else {
                attNum = _this.attUlArea.find("li").length;
            }
            if (imageNum >= tj.quantity || attNum >= tj.quantity) {
                _this.fileInput.attr("disabled",true).css("width","0").css("height","0");
                $.alert($.i18n.prop("cmp.form.insertPic.tips.alert.limitFilesNum",tj.quantity));
                return false;
            } else {
                var fileFormHtml = '<form enctype="multipart/form-data" method="post" id="form_upload" name="uploadForm" ></form>';  //用于file提交的form
                _this.fileForm = $(fileFormHtml);
                _this.fileInput.attr("form","form_upload");
                return true;
            }
        },
        /**
         * 选择附件
         */
        chooseFile : function(tj) {
            var _this = this;
            _this.fileInput.unbind("change").bind("change",function(e) {
                _this.fileRead(_this.fileForm,_this.fileInput,e,tj);
            });
        },

        /**
         * 读取附件数据
         * @param fileForm
         * @param fileInput
         * @param e
         * @returns {boolean}
         */
        fileRead : function(fileForm,fileInput,e,tj) {
            var _this = this;
            var receiveType = (tj.extensions == undefined)?"" : tj.extensions;
            var action = MFormConfig.uploadFileUrl +
                "&type="+(tj.customType == undefined?0:tj.customType)+
                "&firstSave="+(tj.firstSave == undefined?"":tj.firstSave)+
                "&applicationCategory="+(tj.applicationCategory == undefined?"":tj.applicationCategory)+
                "&extensions="+receiveType+
                "&quantity="+(tj.quantity == undefined?"":tj.quantity)+
                "&isEncrypt="+(tj.isEncrypt == undefined?"" :tj.isEncrypt)+
                "&maxSize="+(tj.maxSize == undefined?"" : tj.maxSize)+
                "&destDirectory="+
                "&attachmentTrId="+(tj.attachmentTrId == undefined?"" : tj.attachmentTrId)+
                "&embedInput="+(tj.embedInput == undefined?"" : tj.embedInput)+
                (tj.selectRepeatSkipOrCover == undefined? "":("&selectRepeatSkipOrCover=" + tj.showReplaceOrAppend))+
                "&callMethod="+(tj.callMethod == undefined ? "" : tj.callMethod)+
                "&takeOver="+(tj.takeOver == undefined? "" : tj.takeOver)+
                "&isShowImg="+(tj.isShowImg == undefined? "" :tj.isShowImg)+
                "&from=a8genius";

            fileForm.attr("action",action);
            var file = e.target.files[0];
            var fileName = file.name;
            var fileSize = file.size;
            var fileSuffix = fileName.substring(fileName.lastIndexOf(".") + 1, fileName.length);//文件后缀名
            if ((receiveType != "") && receiveType.indexOf(fileSuffix) < 0) {
                $.alert($.i18n.prop("cmp.form.insertPic.tips.alert.limitFilesType",tj.extensions));
                fileInput.val("");
                fileForm[0].reset();
                fileForm.remove();
                return false;
            }
            if (fileSize > tj.maxSize) {
                $.alert($.i18n.prop("cmp.form.insertPic.tips.alert.limitFileSize",MUtils.getAttSize(tj.maxSize)));
                fileInput.val("");
                fileForm[0].reset();
                fileForm.remove();
                return false;
            }
            fileForm.ajaxSubmit({
                beforeSubmit : function() {
                  var loadingCallback = _this.options.loadingCallback;
                    if(loadingCallback) {
                        var callback = new Function(loadingCallback + '()');
                        callback();
                    }else {
                        var height = $(document).height();
                        var top = $(document).scrollTop();
                        _this.uploadingShieldLayer.css("height",height).css("top",top);
                        _this.uploadingShieldLayer.appendTo(document.body);
                    }
                },
                success: function(data) {  //异步提交
                    var loadedCallback = _this.options.loadedCallback;
                    var displayFile = _this.saveFileData(data,fileForm,tj);
                    if(loadedCallback) {
                        var callback = new Function(loadedCallback + '('+data+')');
                        callback();
                        myCMPFormScroll.refresh();
                    }else {
                        _this.uploadingShieldLayer.remove();
                        _this.createFileDisplayArea(displayFile);
                    }
                    _this.deleteAtt(tj,displayFile);
//                    _this.downloadFile(displayFile);//上传的文件不提供下载功能，只有回填才下载
                },
                error : function(data) {
                    var failedCallback = _this.options.failedCallback;
                    if(failedCallback) {
                        var callback = new Function(failedCallback + '()');
                        callback();
                    }else {
                        $.alert(data);
                        _this.uploadingShieldLayer.remove();
                    }
                }
            });
        },
        /**
         * 保存附件数据
         * @param data
         * @param fileForm
         * @param isBackfill
         * @returns {attachment|*}
         */
        saveFileData : function(data,fileForm,tj) {
            var _this = this;
            var fileData = eval("" + data);
            var fileId = -1;
            var fileURL = null;
            var createDate = "";
            var suffix = "";
            var fileName = "";
            var fileSize = "";
            var v = "";
            var type = "";
            var description = "";
            var icon = "";
            var reference = "";
            var mimeType = "";
            var categeory = "";
            var subReference = "";
            var sort = "";
            var genesisId = "";
            var officeTransformEnable = "";
            var n = false;
            var extraMap = {};
            var needClone = false;
            var hasSaved = false;
            if(fileData.length >0) {
                for (var i = 0; i < fileData.length; i++) {
                    fileId = fileData[i].id;
                    fileURL = fileData[i].fileUrl;
                    createDate = fileData[i].createdate;
                    suffix = fileData[i].extension;
                    fileName = fileData[i].filename;
                    fileSize = fileData[i].size;
                    v = fileData[i].v;
                    type = fileData[i].type;
                    description = fileData[i].description;
                    icon = fileData[i].icon;
                    reference = fileData[i].reference;
                    mimeType = fileData[i].mimeType;
                    categeory = fileData[i].category+"";
                    subReference = fileData[i].subReference;
                    sort = fileData[i].sort;
                    genesisId = fileData[i].genesisId;
                    officeTransformEnable = fileData[i].officeTransformEnable;
                    n = fileData[i].new;
                    extraMap = fileData[i].extraMap;
                    needClone = fileData[i].needClone;
                    hasSaved = fileData[i].hasSaved;
                }
            }

            var attachment = _this.saveAttachment(tj,fileId,reference,subReference,categeory,type,fileName,mimeType,createDate,fileSize,fileURL,description,needClone,suffix,icon,false,officeTransformEnable,v,hasSaved,false);
            if(fileForm) {
                _this.fileInput.val("");
                fileForm[0].reset();
                fileForm.remove();
            }
            attachment.sub = subReference;
            return attachment;
        },

        /**
         * 解析attsdata中的数据
         * @param backfillFile
         */
        parseBackfillFile : function(tj,backfillFile) {
            var _this = this;
            var fileArrObj = eval("" + backfillFile);
            var len = fileArrObj.length;
            var width = _this.options.displayWidth;
            var height = _this.options.displayHeight;
            for(var i = 0; i < len; i ++) {
                var fileUrl = fileArrObj[i].fileUrl;

                var fileId = fileArrObj[i].id;
                var createData = interceptDate(fileArrObj[i].createdate);
                var suffix = fileArrObj[i].extension;
                var fileName = fileArrObj[i].filename;
                var name = fileName.substring(0,fileName.indexOf("."));
                var size = fileArrObj[i].size;
                var v = fileArrObj[i].v;
                var type = fileArrObj[i].type;
                var description = fileArrObj[i].description;
                var icon = fileArrObj[i].icon;
                var reference = fileArrObj[i].reference;
                var mimeType = fileArrObj[i].mimeType;
                var categeory = fileArrObj[i].category;
                var subReference = fileArrObj[i].subReference;
                var sort = fileArrObj[i].sort;
                var genesisId = fileArrObj[i].genesisId;
                var officeTransformEnable = fileArrObj[i].officeTransformEnable;
                var n = fileArrObj[i].new;
                var extraMap = fileArrObj[i].extraMap;
                var needClone = fileArrObj[i].needClone;
                var hasSaved = fileArrObj[i].hasSaved;
                var attchment = _this.saveAttachment(tj,fileId,reference,subReference,categeory,type,fileName,mimeType,createData,size,fileUrl,description,needClone,suffix,icon,false,officeTransformEnable,v,hasSaved,true);
                attchment.sub = subReference;
                _this.createFileDisplayArea(attchment);
                _this.deleteAtt(tj,attchment);
                _this.downloadFile(attchment);
            }
        },
        saveAttachment : function(tj,fileId,reference,subReference,categeory,type,fileName,mimeType,createDate,fileSize,fileURL,description,needClone,suffix,icon,isOnlineEdit,officeTransformEnable,v,hasSaved,isBackfill) {
            var canDelete = tj.canDeleteOriginalAtts == null ? true : tj.canDeleteOriginalAtts;
            var poi = "";
            if(!isBackfill) {
                poi = tj.attachmentTrId;
            }else {
                poi = subReference;
            }
            needClone = needClone == null ? false : needClone;
            description = description == null ? "" : description;
            if(attachDelete!=null) canDelete = attachDelete;
            if(fileURL == null) fileURL = fileName;
            var attachment = new Attachment(fileId,reference,poi,categeory,type,fileName,mimeType,createDate,fileSize,fileURL,description,needClone,suffix,icon,false,officeTransformEnable,v);
            attachment.showArea = poi;
            attachment.embedInput = tj.embedInput;
            attachment.hasSaved = hasSaved ?hasSaved : null;
            attachment.isBackfill = isBackfill;
            if(tj.canFavourite != null) attachment.canFavourite = tj.canFavourite;
            attachment.hasFavorite = (tj.hasFavorite)? tj.hasFavorite : undefined;
            if(tj.isShowImg != null) attachment.isShowImg = tj.isShowImg;
            if(fileUploadAttachment != null){
                if(fileUploadAttachment.containsKey(fileURL)){
                    return attachment;
                }
                fileUploadAttachment.put(fileURL, attachment);
            }else{
                if(fileUploadAttachments.containsKey(fileURL)){
                    return attachment;
                }
                fileUploadAttachments.put(fileURL, attachment);
            }

            //更新附件、关联文档隐藏域
            var file=attachment;
            var valueInput = $(tj.srcElement).find("#" + file.embedInput);
            if(valueInput.size() > 0) {
            	valueInput.attr("value",poi);
            }

            if(attachCount)
                showAttachmentNumber(type,attachment);
            if(typeof(addScrollForDocument) =="function"){
                addScrollForDocument();
            }

            return attachment;
        },
        /**
         * 创建附件显示
         * @param attachment
         */
        createFileDisplayArea : function(attachment) {
            var _this = this;
            var showArea = attachment.showArea;
            var sub = attachment.sub;
            var thisShowAreaId = "";
            if(attachment.isBackfill) {
                    if(showArea == sub){
                        thisShowAreaId = (_this.imgArea) ? _this.imgArea.attr("id") : ((_this.attUlArea)? _this.attUlArea.attr("id") : "");
                        if(sub != thisShowAreaId.replace("attachmentArea","")) {
                            return ;   //不做渲染

                        }
                    }else {
                        return ;
                    }
            }
            if(!attachment){
                return
            }
            var _this = this;
            var contextPath  = _ctxPath ? _ctxPath : "/seeyon";
            var displayBox;
            loadInit();
            var displayAttData = _this.createDisplayAttObj(attachment.id,attachment.fileUrl,attachment.extension,
                attachment.filename,attachment.filename.split(".")[1],attachment.size,attachment.v,attachment.createDate);

            if(_this.options.isImageWidget) {
                displayBox = _this.renderImgBox(attachment.fileUrl2,attachment.filename,attachment.size,attachment.v,attachment.hasSaved,attachment.officeTransformEnable,
                    attachment.createDate,_this.options.displayWidth,_this.options.displayHeight,contextPath);

                displayBox.appendTo(_this.imgArea);
            }else {
                displayBox = _this.renderAttBox(displayAttData);
                displayBox.appendTo(_this.attUlArea);
            }

            if(!attachment.isBackfill) {
                myCMPFormScroll.refresh();
            }

        },

        /**
         *
         * @param fileUrl
         * @param fileName
         * @param fileSize
         * @param v
         * @param hasSaved
         * @param isCanTransform
         * @param createDate
         * @param width
         * @param height
         * @param contextPath
         * @returns {*|jQuery|HTMLElement}
         */
        renderImgBox : function(fileUrl,fileName,fileSize,v,hasSaved,isCanTransform,createDate,width,height,contextPath) {
            var imgBox = "<div class='insertPic_displayArea attachment_block'  style='width: "+width+"px' id='attachmentDiv_"+fileUrl+"' >" +
                            "<div class='insertPic_displayPicBox' style='height: "+height+"px;position:relative;'>" +

                                //添加图片查看
//                                "<img onclick=\"window.showModalDialog($(this).attr('src'),window,'dialogHeight:768px;dialogWidth:1024px;center:yes;resizable:yes;')\" src=\""+contextPath+"/fileUpload.do?method=showRTE&fileId="+fileUrl+"&createDate=" + interceptDate(createDate) + "&type=image\" style='width:"+width+"px;height:"+height+"px'/>" ;
            "<img onclick=\"form_uploadFile.seeImg($(this).attr('src'))\" src=\""+contextPath+"/fileUpload.do?method=showRTE&fileId="+fileUrl+"&createDate=" + interceptDate(createDate) + "&type=image\" style='width:"+width+"px;height:"+height+"px'/>" ;
                if(isCanTransform && hasSaved) {
                    imgBox += "[<a href=\"" + contextPath + "/officeTrans.do?method=view&fileId=" + fileUrl + "&createDate=" + interceptDate(createDate) + "&filename=" + encodeURIComponent(fileName) + "\" target='downloadFileFrame' style='font-size:12px;color:#007CD2;'></a>]";
                }
                imgBox += "<div style='position: absolute;z-index: 150;top: -10px;right: -10px;' id='delPicIcon_"+fileUrl+"'>" +
                            "<span class='cmpPhone40 cmp_picture_close_40'></span>" +
                            "</div>" +
                        "</div>" +
                          "<div class='insertPic_displayName'>"+fileName+"</div>" +
                          "<div class='insertPic_displayName'>"+MUtils.getAttSize(fileSize)+"</div>" +
                       "</div>";
            return $(imgBox);
        },

        renderAttBox : function(attObj) {
            var attTplPath = MFormConfig.CMPPluginsUrl + "/plugins/form/widget/tpl/cmp_att_tpl.html";
            var attTpl = MUtils.readFileContent(attTplPath);
            var attHtml = MUtils.tpl(attTpl, attObj);
            return $(attHtml);
        },

        deleteAtt : function(tj,file) {
            var _this = this;
            var ctrlWidth = _this.options.ctrl.width();
            var ctrlHeight = _this.options.ctrl.height();
            var imgBoxId = file.fileUrl;
            var createdate = file.createDate;
            var isBackfill = file.isBackfill;
            var imgBox = $("#attachmentDiv_" + imgBoxId);
            var delCtrl = $("#delPicIcon_" + imgBoxId);
            var delCallback = _this.options.delCallback;
            delCtrl.bind("touchstart",function(e) {
                e.stopPropagation();
            });
            delCtrl.bind("touchend",function(e) {
                e.stopPropagation();
            });
            delCtrl.unbind("click").bind("click",function(event) {
                event.stopPropagation();
                if(isBackfill) {
                    if((tj.canDeleteOriginalAtts && tj.canDeleteOriginalAtts == true) || typeof tj.canDeleteOriginalAtts == "undefined") {
                        imgBox.remove();
                        $(this).remove();
                        if(fileUploadAttachment != null) {
                            if(fileUploadAttachment.containsKey(imgBoxId)) {
                                fileUploadAttachment.clear();
                            }
                        }else if(fileUploadAttachments != null) {
                            if(fileUploadAttachments.containsKey(imgBoxId)) {
                                fileUploadAttachments.remove(imgBoxId);
                            }
                        }

                    }else if(tj.canDeleteOriginalAtts && tj.canDeleteOriginalAtts == false) {
                        $.alert($.i18n.prop("cmp.form.insertPic.tips.alert.cantDeleteOriginalAtts"));
                    }
                }else {
                    if(delCallback) {
                        var callback = new Function(delCallback + '("'+imgBoxId+'")');
                        callback();
                    }else {
                        imgBox.remove();
                        $(this).remove();
                    }
                    if(fileUploadAttachment != null) {
                        if(fileUploadAttachment.containsKey(imgBoxId)) {
                            fileUploadAttachment.clear();
                        }
                    }else if(fileUploadAttachments != null) {
                        var keys = fileUploadAttachments.keys();
                        if(fileUploadAttachments.containsKey(imgBoxId)) {
                            fileUploadAttachments.remove(imgBoxId);
                        }
                    }
                    myCMPFormScroll.refresh();
                }
                _this.removeAtt(imgBoxId,createdate);
                _this.fileInput.attr("disabled",false).css("width",ctrlWidth).css("height",ctrlHeight);  //删除的时候都把file控件的尺寸重新设置
            });
        },
        createDisplayAttObj : function(fileId,fileUrl,suffix,filename,name,size,v,createDate) {
            var AttObj = new Object();
            AttObj.fileId = fileId;
            AttObj.fileUrl = fileUrl;
            AttObj.suffix = suffix;
            AttObj.filename = filename;
            AttObj.name = name;
            AttObj.size = size;
            AttObj.v = v;
            AttObj.createDate = createDate;
            return AttObj;
        },

        //删除服务器端的文件
        removeAtt : function(fileID,createFileDate) {
            var url = (_ctxPath) ? _ctxPath + "/attachment.do?method=deleteFile" : "/seeyon/fileUpload.do?method=deleteFile";
            $.ajax({
                url:url,
                type:'GET',
                data:{'fileId':fileID,'createDate':createFileDate},
                async:false,
                success:function(data){
                }
            });
        },
        //下载文件
        downloadFile : function(file) {
            var imgBoxId = file.fileUrl;
            var imgBox = $("#attachmentDiv_" + imgBoxId);
            var a = imgBox.find("a");
            var src = a.attr("src");
            a.bind("touchstart",function(e) {
                e.stopPropagation();
            });
            a.bind("touchend",function(e) {
                e.stopPropagation();
            });
            a.unbind("click").bind("click",function() {
                window.location.href = src;
            });
        }


    }

    //截取返回的createDate数据，去掉时间
    var interceptDate = function(dateStr) {
        var regex = "-";
        var dateStrArr = dateStr.split(regex);
        var year = dateStrArr[0];
        var month = dateStrArr[1];
        var day = dateStrArr[2].substring(0,2);
        return year + "-" + month + "-" + day;
    }

    form_uploadFile.seeImg = function(src) {
        var width = $(document).width();
        var height = $(document).height();
        var top = $(document).scrollTop();
        var seeImgLayerHtml = '<div class="insertPic_seeImgPanel">' +
            '   <div class="insertPic_seeImgTitle">' +
            '       <div class="closeBtnArea"><span class="closeBtn"></span></div>'+
            '   </div>'+
            '   <div class="insertPic_seeImgContent">' +
            '       <img src="'+src+'">'+
            '   </div>'+
            '   <div class="insertPic_seeImgFooter"></div>'+
            '</div>';
        var seeImgLayer = $(seeImgLayerHtml);
        seeImgLayer.css("top",top).css("height",height).css("width",width);
        seeImgLayer.appendTo(document.body);
        var closeBtn = $(".closeBtnArea",seeImgLayer);
        closeBtn.unbind("click").bind("click",function() {
            seeImgLayer.remove();
        });
    }

    return form_uploadFile;
})();
//form_uploadFile.js e
//form_assDoc.js s
/**
 * Created by Administrator on 2015-3-21.
 */
var form_assDoc = (function() {

    function form_assDoc(tj,options) {
        var _this = this;
        MFormAssDocConstant = {
            assDocType_collaboration : 1,
            assDocType_archive : 2,

            assDocClassType_collaboration : 'MCollaborationListItem',
            assDocClassType_archive : 'MArchiveListItem'
        }
        _this.options = $.extend(true,{
            choosedCallback : undefined,
            delCallback : undefined,
            backfillCallback : undefined,
            attsdata : null
        },options);
        var compDiv = $(tj.srcElement);
        var compContainer = compDiv.parent();
        if(!compContainer || compContainer.length == 0) {
            throw "please defined file displayArea";
        }
        if(tj.embedInput){
            compDiv.append('<input type="text"  id="'+(tj.embedInput ? tj.embedInput : '')+'" ' +
                'name="'+(tj.embedInput ? tj.embedInput : '')+'" value="" style="display:none;">');
        }
        compContainer.css("height","auto");
        _this.assDocUlArea = $('<ul style="float:right;width:83%;" class="insertPic_displayAttUl padding_lr_10 padding_tb_5" ' +
            'id="attachment2Area'+tj.attachmentTrId+'" poi="'+tj.attachmentTrId+'" embedinput="'+tj.embedInput+'"></ul>');
        compContainer.append(_this.assDocUlArea);

        if(_this.options.attsdata && MUtils.judgeObjNotNull(_this.options.attsdata)) { //处理回填值的展示（无删除操作）
            _this.parseBackfillAccDoc(tj,_this.options.attsdata);
        }
    }
    form_assDoc.prototype = {
        //关联文档分支
        createAssDocList : function(tj) {
            var _this = this;
            var fillbackMap = {};//回填值对象
            fillbackMap['collaboration'] = [];//协同对象数组
            fillbackMap['archive'] = [];//文档对象数组
            fillbackMap['collaborationID'] = [];//协同相应的ID数组
            fillbackMap['archiveID'] = [];//文档相应的ID数组
            if(_this.assDocUlArea.children('li').length > 0) {
                _this.assDocUlArea.children('li').each(function() {
                    var dataObj = $.parseJSON($(this).attr("data"));
                    if(dataObj.classType == MFormAssDocConstant.assDocClassType_collaboration) {
                        fillbackMap['collaboration'].push(dataObj);
                        fillbackMap['collaborationID'].push(dataObj.affairID);
                    }else if(dataObj.classType == MFormAssDocConstant.assDocClassType_archive) {
                        fillbackMap['archive'].push(dataObj);
                        fillbackMap['archiveID'].push(dataObj.archiveID);
                    }
                });
            }
            var assDocWidget = new MAssDoc({
                serverURL : MFormConfig.serverURL,
                backfillData : fillbackMap,
                okCallback : function(collaborationData,archiveData) {
                    var choosedCallback = _this.options.choosedCallback;
                    if(choosedCallback) {
                        var callback = new Function(choosedCallback + '('+collaborationData,archiveData+')');
                        callback();
                        myCMPFormScroll.refresh();
                    }else {
                        _this.handleSelectedAssDocData(tj,collaborationData,archiveData);
                        assDocWidget.close();
                        assDocWidget = null;
                    }

                },
                closeCallback : function(collaborationData,archiveData) {
                    assDocWidget.close();
                    assDocWidget = null;
                }
            });
        },
        /*=========================================关联文档相关数据的处理===================================================*/
        parseBackfillAccDoc : function(tj,attsdata) {
            var _this = this;
            var assDocArrObj = eval("" + attsdata);
            var len = assDocArrObj.length;
            for(var i = 0; i < len; i ++) {
                var displayObj = null;
                var mimeType = assDocArrObj[i].mimeType;
                var fileUrl = assDocArrObj[i].fileUrl;
                var filename = assDocArrObj[i].filename;
                var poi = assDocArrObj[i].subReference;
                if(poi != tj.attachmentTrId) continue; //回填值的时候，如果poi值与输入域的位置值不相等的话就不做渲染,避免位置错乱
                if(mimeType == 'collaboration') {
                    displayObj = _this.displayAssDocObj(MFormAssDocConstant.assDocType_collaboration,-1,fileUrl,filename,'',true,assDocArrObj[i]);
                    _this.renderAssDocBox(displayObj);
                }else if(mimeType == 'km') {
                    var suffix = assDocArrObj[i].extension;
                    var documentType = 3;  //此处应该是服务器端需要返回更多的值，暂时这样，待上线后再和表单组的人商讨
                    if(suffix != '') documentType = 2;
                    displayObj = _this.displayAssDocObj(MFormAssDocConstant.assDocClassType_archive,documentType,fileUrl,filename,suffix,true,assDocArrObj[i]);
                    _this.renderAssDocBox(displayObj);
                }
            }
        },
        /**
         * 文档数据选择后的处理
         * @param tj：关键属性
         * @param collaborationData：协同数据
         * @param archiveData：文档数据
         */
        handleSelectedAssDocData : function(tj,collaborationData,archiveData) {
            var _this = this;
            var poi = tj.attachmentTrId;
            var embedInput = tj.embedInput;
            var selectedAssDocHtml = "";
            if(collaborationData.length > 0) {
                for(var i = 0; i < collaborationData.length ; i ++) {
                    var fileUrl = collaborationData[i].affairID;
                    var mimeType = 'collaboration';
                    var filename = collaborationData[i].title;
                    var type = '2';
                    var createDate = collaborationData[i].createDate;
                    var description = collaborationData[i].affairID;
                    var v = collaborationData[i].verifyCode;
                    var displayCollaborationObj = _this.displayAssDocObj(MFormAssDocConstant.assDocType_collaboration,-1,fileUrl,filename,'',false,collaborationData[i]);
                    selectedAssDocHtml += _this.renderAssDocBox(displayCollaborationObj);
                    _this.saveAssDocData(tj,type,filename,mimeType,createDate,'0',fileUrl,true,false,
                                  description,null,mimeType + ".gif",poi,'','',null,null,embedInput);
                }
            }
            if(archiveData.length > 0) {
                for(var i = 0; i < archiveData.length ; i ++) {
                    var fileUrl = archiveData[i].archiveID;
                    var mimeType = 'km';
                    var filename = archiveData[i].title;
                    var type = '2';
                    var createDate = archiveData[i].createTime;
                    var description = archiveData[i].archiveID;
                    var v = archiveData[i].verifyCode;
                    var documentType = archiveData[i].type;
                    var suffix = filename.substring(filename.lastIndexOf(".") + 1);
                    var displayArchiveObj = _this.displayAssDocObj(MFormAssDocConstant.assDocType_archive,documentType,fileUrl,filename,suffix,false,archiveData[i]);
                    selectedAssDocHtml += _this.renderAssDocBox(displayArchiveObj);
                    _this.saveAssDocData(tj,type,filename,mimeType,createDate,'0',fileUrl,true,false,
                        description,null,mimeType + ".gif",poi,'','',null,null,embedInput);
                }
            }
            _this.assDocUlArea.html(selectedAssDocHtml);
            _this.deleteAssDocData();
            myCMPFormScroll.refresh();
        },
        //保存文档数据
        saveAssDocData : function(tj,type, filename, mimeType, createDate, size, fileUrl, canDelete, needClone,
                                  description, extension, icon, poi, reference, category, onlineView, width, embedInput,hasSaved,
                                  isCanTransform,v,canFavourite, isShowImg,id,hasFavorite) {
            var _this = this;
            needClone = (needClone == null)?false : needClone;
            description = (description == null)?'' : description;
            if(attachDelete!=null) canDelete = attachDelete;
            if(fileUrl == null) fileUrl = filename;
            var assDoc = new Attachment(id,reference, poi, category, type, filename, mimeType, createDate, size, fileUrl, description, needClone,extension,icon, false,isCanTransform,v);
            assDoc.showArea = poi;
            assDoc.embedInput = embedInput;
            assDoc.hasSaved =hasSaved;
            assDoc.hasFavorite = hasFavorite;
            if(canFavourite != null) assDoc.canFavourite=canFavourite;
            if(isShowImg != null) assDoc.isShowImg=isShowImg;
            if(fileUploadAttachment != null){
                if(fileUploadAttachment.containsKey(fileUrl)){
                    return assDoc;
                }
                fileUploadAttachment.put(fileUrl, assDoc);
            }else{
                if(fileUploadAttachments.containsKey(fileUrl)){
                    return assDoc;
                }
                fileUploadAttachments.put(fileUrl, assDoc);
            }
            var valueInput = $(tj.srcElement).find("#"+assDoc.embedInput);
            if(valueInput.size() > 0) {
                valueInput.attr("value",poi);
            }
        },
        deleteAssDocData : function() {
            var _this = this;
            var delCallback = _this.options.delCallback;
            _this.assDocUlArea.children("li").each(function() {
                var delCtrl = $(this).find("div[id^=delPicIcon_]");
                var docBoxID = delCtrl.attr("id").replace("delPicIcon_","");
                var  docBox = $(this);
                delCtrl.unbind("tap").bind("tap",function(event) {
                    event.stopPropagation();
                    if(delCallback) {
                        var callback = new Function(delCallback + '("'+docBoxID+'")');
                        callback();
                    }else {
                        docBox.remove();
                        delCtrl.remove();
                    }
                    if(fileUploadAttachment != null) {
                        if(fileUploadAttachment.containsKey(docBoxID)) {
                            fileUploadAttachment.clear();
                        }
                    }else if(fileUploadAttachments != null) {
                        var keys = fileUploadAttachments.keys();
                        if(fileUploadAttachments.containsKey(docBoxID)) {
                            fileUploadAttachments.remove(docBoxID);
                        }
                    }
                    myCMPFormScroll.refresh();
                });
            });
        },
        //渲染文档数据列表
        renderAssDocBox : function(data){
            var _this = this;
            var assdocTplPath = MFormConfig.CMPPluginsUrl + "/plugins/form/widget/tpl/cmp_assdoc_tpl.html";
            var assdocTpl = MUtils.readFileContent(assdocTplPath);
            var assdocHtml = MUtils.tpl(assdocTpl, data);
            return assdocHtml;
        },
        /**
         * 显示关联文档对象
         * @param assDocType:文档来自（1：协同；2：文档中心）
         * @param documentType：文档类型（只有文档中心的文档才做判断；-1，是来自协同的文档，不做类型判断；2，一般文件需要对后缀进行判断；3~18，是协同、会议等文档类型）
         * @param fileUrl：文档id
         * @param filename：文档名称
         * @param suffix：文档后缀（只有文档中心并且documentType=2的文档才做判断）
         * @param isBackfill：是否是回填数据（false：可以删除；true：不能删除）
         * @param assData:数据对象（作json处理）
         */
        displayAssDocObj : function(assDocType,documentType,fileUrl,filename,suffix,isBackfill,assData) {
            var assDocObj = new Object();
            assDocObj.assDocType = assDocType;
            assDocObj.documentType = documentType;
            assDocObj.fileUrl = fileUrl;
            assDocObj.filename = filename;
            assDocObj.suffix = suffix;
            assDocObj.isBackfill = isBackfill;
            assDocObj.assData = $.toJSON(assData);
            return assDocObj;
        }
    }

    return form_assDoc;
})();
//form_assDoc.js e
//form_assForm.js s
/**
 * Created by Administrator on 2015-6-15.
 */
var form_assForm = (function() {
    function form_assForm(){}
    form_assForm.prototype = {
        showAssDocRelationList : function(relationParams) {
            var _this = this;
            var assFormWidget = new MAssForm({
                serverURL : MFormConfig.serverURL,
                relationParams : relationParams,
                currentAccountID : MChooseConfig.currentAccountID,
                okCallback : function(result) {
                    var retObj = $.parseJSON(result);
                    if(retObj != null && retObj.toFormId != null) {
                        var dataId = retObj.dataId;
                        var toFormId = retObj.toFormId;
                        var tempFormManager = new formManager();//调用PC的manager
                        var params = {};
                        params['selectArray'] = retObj.selectArray;
                        params['fieldName'] = relationParams.fieldName;
                        params['rightId'] = $("#rightId").val();
                        params['toFormId'] = toFormId;
                        params['fromFormId'] = form.id;
                        params['recordId'] = relationParams.recodeID;
                        params['fromDataId'] = $("#contentDataId").val();
                        tempFormManager.dealFormRelation(params,{
                            success : function(obj) {
                                _this.handleFormRelationData(obj);
                            }
                        });
                    }
                },
                closeCallback : function() {

                }
            });
        },
        /*====================================关联表单的数据处理============================================================*/
        /**
         * 关联表单数据选择后的相关处理
         * @param formRelationData:后台处理后的返回值
         */
        handleFormRelationData : function(formRelationData) {
            var dataObj = $.parseJSON(formRelationData);
            if(dataObj.success == true || dataObj.success == "true"){
                var datas = dataObj.datas;
                var result = dataObj.results;
                if(datas && datas.length > 0) {
                    //TODO 暂时还不清楚的东西
                }else {
                    formCalcResultsBackFill(result);//调用pc接口
                }
            }else {
                $.alert(dataObj.errorMsg);
            }
        }
    }
    return form_assForm;
})();
//form_assForm.js e
//form_onlyNum.js s
/**
 * Created by Administrator on 2015-3-23.
 */
var form_onlyNum = (function () {

    MNumberFormat = {
        C_sFormat_Percent : "%",
        C_sFormat_Thousands : "##,###,###0",
        C_sFormat_ZeroCover : "0"
    }

    function form_onlyNum(tj, options) {
        var _this = this;
        _this.options = $.extend(true, {
            fieldType: "decimalDigits",
            formatType: "",
            decimalDigit : 0
        }, options);
        var ctrl = $(tj.srcElement);
        var id = ctrl.attr("id");
        var name = ctrl.attr("name");
        var value = ctrl.val();   //回填值
        _this.numTypeInput = null;
        _this.displayTextInput = null;
        if(value != "" || value.length > 0) {
            ctrl.attr("oldVal",value);
        }
        if (_this.options.formatType == "" && _this.options.formatType.length == 0) {
            _this.numTypeInput = ctrl;
        }else {
            ctrl.css("display","none");
            var defaultDisplayInput = ctrl.parent().find("input[id$=_txt]");
            if(defaultDisplayInput.attr("onfocus").length > 0) defaultDisplayInput.removeAttr("onfocus"); //去掉A8默认的方法属性
            if(defaultDisplayInput.attr("onblur").length > 0) defaultDisplayInput.removeAttr("onblur");  //去掉A8默认的方法属性
            if(defaultDisplayInput.attr("onkeyup").length > 0) defaultDisplayInput.removeAttr("onkeyup");//去掉A8默认的方法属性
            var formatVal = (value == "" && value.length == 0) ? "" : getDisplayVal(value,_this.options.formatType,_this.options.decimalDigit);
            defaultDisplayInput.val(formatVal).addClass("onlyNum_numInput");
            _this.displayTextInput = defaultDisplayInput;
            _this.numTypeInput = ctrl;

        }
        var trigger = (ctrl.css("display") == "none") ? _this.displayTextInput : _this.numTypeInput;
        trigger.unbind("focus").bind("focus",function() {
            var oldval = _this.numTypeInput.attr("oldVal");
            var oldValue;
            if(typeof oldval != "undefined") {
                oldValue = oldval;
            }else {
                _this.numTypeInput.attr("oldVal","");
                oldValue = "";
            }
            $(this).val(oldValue);

        });
        trigger.unbind("blur").bind("blur",function() {
            var value = $(this).val();
            value = _this.handleDecimalDigit(value);
            var displayVal = _this.bindValueBlurHandle(value);
            _this.numTypeInput.val(value);
            calc(_this.numTypeInput);//调用计算接口
            _this.numTypeInput.attr("oldVal",value);
            $(this).val(displayVal);

        });
        trigger.unbind("keyup").bind("keyup",function() {
            formFieldPercentFunctionKeyUpfunction(trigger);
        });


    }

    form_onlyNum.prototype = {
        bindValueBlurHandle: function (val) {
            var _this = this;
            return getDisplayVal(val,_this.options.formatType,_this.options.decimalDigit);
        },
        handleDecimalDigit : function(val) {
            if(val == "" || val.length == 0)
                return "";
            var _this=  this;
            var decimalDigit = _this.options.decimalDigit;
            var index = val.indexOf(".");
            var result = "";
            if(index == -1)
                return decimalDigit > 0 ? (val + "." + MUtils.repeatStr("0",decimalDigit)) : (val) ;


            if(index > -1) {
                var integer = val.substring(0,index)*1;
                var decimal = val.substring(index+1);
                len = decimal.length;
                decimal = decimal.substring(0,decimalDigit) + ((len - decimalDigit <= 0) ? MUtils.repeatStr("0",((decimalDigit + 1) - len)) : decimal.substring(decimalDigit,(decimalDigit+1)));

                if(parseInt(decimal) == 0)
                    return integer + "." +decimal.substring(0,decimal.length-1);

                var imitatedDecimal = "1." + decimal;
                var series = 1;
                for(var i = 0,len = decimal.length; i < len; i ++) {
                    series *= 10;
                }
                imitatedDecimal = parseInt(imitatedDecimal * series);
                var last = Math.abs(series == 1 ? 0 : imitatedDecimal % 10);
                if(last > 4) {
                    imitatedDecimal += 10;
                }
                imitatedDecimal = imitatedDecimal/series;
                if(imitatedDecimal > 2) {
                    integer += 1;
                }
                imitatedDecimal = imitatedDecimal.toString().substring(2);
                imitatedDecimal = imitatedDecimal.substring(0,decimalDigit);
                result = integer + "." + imitatedDecimal;
            }
            return result;

        }
    }
    var isNumber = function(value) {
        if (typeof value == "string") {
            value = value;
        }
        return /^[-+]?\d*([\.]\d+)?$/.test(value);
    }

    var formFieldPercentFunctionKeyUpfunction = function(tempThis){
        var value = tempThis.val();
        if(value.length>0 && value!="-"){
            var index = value.lastIndexOf("%");
            var numberValue = value;
            if(index>-1){
                numberValue = value.sub(0, index);
            }
            if(isNaN(numberValue) || !/^[-+]?\d+(\.\d*)?$/.test(value)){
                if(!isNumber(numberValue)){
                    numberValue = numberValue.replace(/[^\d]+/g,"");
                }
                tempThis.val(numberValue);
            }else if(numberValue!="0"&&numberValue.indexOf(".")!=1&&numberValue.indexOf("0")==0){//02323这种数字的处理
                while(numberValue.indexOf("0")==0){
                    numberValue = numberValue.substring(1);
                }
                tempThis.val(numberValue);
            }
        }
        tempThis = null;
    }

    var getDisplayVal = function(value,formatType,digNum) {
        if(value == "" || value.length == 0)
            return "";
        if((digNum==""||digNum==0)&&(value.indexOf(".")!=-1&&value.indexOf(".0")!=value.length-2)){
            $.alert("整数字段包含的小数位将自动四舍五入");
            value = value.substring(0,value.indexOf("."));
            return value;

        }

        if(formatType==MNumberFormat.C_sFormat_Thousands){
            var index = value.indexOf(".");
            if(index >-1){
                var integer  = value.substring(0,index);
                var decimal = value.substring(index);
            } else {
                integer = value;
                decimal = "";
            }
            var re=/(\d{1,3})(?=(\d{3})+(?:$|\.))/g;
            return integer.replace(re,"$1,")+decimal;
        } else if(formatType==MNumberFormat.C_sFormat_Percent){
            var hundredNum = (value.toFixed(digNum)*100).toFixed(digNum-2>0?digNum-2:0);
            if(hundredNum==0){
                var zeroStr = "";
                for(var i=0;i<digNum;i++){
                    zeroStr+="0";
                }
                return "0"+(zeroStr==""?"":".")+zeroStr+"%";
            }
            return hundredNum+"%";
        }
        return value;
    }

    return form_onlyNum;
})();
//form_onlyNum.js e
//form_map.js s
/**
 * Created by Administrator on 2015-3-26.
 */
var form_map = (function () {
	var mapObj = null;
    MMapService = {
        C_sMMapServiceBaseUrl: "http://" + document.location.host + "/seeyon/ajax.do?method=ajaxAction",
        C_sMMapServiceManagerName: "lbsManager",
        C_sMMapServiceMethod_saveMap: "transSaveAttendanceInfo",
        C_sMMapFormServiceManagerName : "formManager",
        C_sMMapFormServiceMethod_dealLbsFieldRelation : "dealLbsFieldRelation"
    }
    function form_map(tj) {
        var _this = this;
        _this.tj = tj;
        _this.ctrl = $(tj.srcElement);
    }

    form_map.prototype = {
        openMapWidget: function () {
            var _this = this;
            var ctrlVal = _this.ctrl.val();
            var fillbackText = (ctrlVal == "" && ctrlVal.length == 0) ? "" :ctrlVal.replace(/[0-9]{4}-[0-1]?[0-9]{1}-[0-3]?[0-9]{1}/, "").trim();
            var fillbackLng = (typeof _this.ctrl.attr("lng") == 'undefined') ? '' : _this.ctrl.attr("lng");
            var fillbackLat = (typeof _this.ctrl.attr("lat") == 'undefined') ? '' : _this.ctrl.attr("lat");
            var fillbackVal = {
                text : fillbackText,
                lng : fillbackLng,
                lat : fillbackLat
            }

            var fillbackVal = ((fillbackText != "")
                && (typeof fillbackLng != 'undefined') && (typeof fillbackLat != 'undefined'))
                ? {text : fillbackText,lng : fillbackLng,lat : fillbackLat} : '';
            mapObj = new MLbs_map(document.body, {
                basePath : MFormConfig.serverURL,
                height : $(window).height(),
                callback : function(data) {
                    _this.handleMapDataFromServer(data);
                    mapObj.closeEvent();
                    mapObj = null;
                },
                fillBackData : fillbackVal
            });
        },
        mapLacate: function () {
            var _this = this;
            mapObj = new MLbs_location(document.body,{
                callback : function(data) {
                    _this.handleMapDataFromServer(data);
                    mapObj = null;
                }
            });
        },
        handleMapDataFromServer : function(data) {
            var _this = this;
            var currentField = _this.ctrl.next("input[id="+_this.tj.fieldName+"]");
            if(data != null) {
                var params = data;
                params.referenceRecordId = _this.tj.referenceRecordId;
                params.referenceFormId = _this.tj.referenceFormId;
                params.referenceFormMasterDataId = _this.tj.referenceFormMasterDataId;
                params.referenceFieldName = _this.tj.fieldName;
                if (params) {
                    var requestAjax = MUtils.mRequestAjaxParams(
                        MMapService.C_sMMapServiceManagerName,
                        MMapService.C_sMMapServiceMethod_saveMap, params);
                    MUtils.mRequestForAjax(MMapService.C_sMMapServiceBaseUrl, requestAjax, function (result) {
                        var lbsId = result.lbsId;
                        var lbsAddr = result.lbsAddr;
                        currentField.val(lbsId);
                        _this.ctrl.val(lbsAddr);
                        _this.ctrl.attr("lng",result.lbsLongitude);
                        _this.ctrl.attr("lat",result.lbsLatitude);
                        _this.tj.targetDom = currentField;
                        handleRelationMapData(result,_this.tj);
                    });
                }
            }else {
                currentField.val("");
                _this.ctrl.val("");
                _this.tj.targetDom = currentField;
                handleRelationMapData("",_this.tj);
            }

        }
    }
        /*======================处理关联数据和计算式（调用表单组的接口）===============*/
    var handleRelationMapData = function(data,options) {
        mapPointCallBack(data,options);
    }

    return form_map;
})();
//form_map.js e
//MFormCompRenderBridge.js s
var MFormCompRenderBridge = (function() {

    function MFormCompRenderBridge() {}
    MFormCommonWidgetConstant = {
        C_iCommonWidgetName_fullScreenLoadingShieldLayer : 1,
        C_iCommonWidgetName_loadingWithNoShieldLayer : 2
    }

    /**
     * 选人
     * @param tj
     */
    MFormCompRenderBridge.bindSelectOrg = function(tj) {
        var currentCtrl = tj.srcElement;
        var ctrlID = currentCtrl.attr("id");
        currentCtrl.attr("id",ctrlID + "_txt").attr("name",ctrlID + "_txt").addClass("triangle");
        currentCtrl.removeAttr("onblur");//去掉失去焦点时的计算时机
        var hiddenCtrlID = ctrlID;
        var returnValueCtrl = $('<input type="hidden" name="'+hiddenCtrlID+'" id="'+hiddenCtrlID+'" style="display:none;">');
        currentCtrl.after(returnValueCtrl);
        var oldValue = tj.value;
        var oldText = tj.text;

        var parent = $(tj.srcElement).parent();
        var str = parent.attr("fieldval");
        var obj = $.parseJSON(str);
        var inputType = obj ? obj.inputType : undefined;
        var isMulti = false;
        if(inputType){
            if(inputType.indexOf("multi") > -1) {
                isMulti = true;
            }
        }
        var selectOrg = new form_selectOrg(tj,isMulti);
        var checkCallbackValueMap = new MMap();

        if(oldValue && oldValue.length > 0) {
            returnValueCtrl.val(oldValue);
            returnValueCtrl.attr("oldVal",oldValue);
            if(isMulti) {
                currentCtrl.text(oldText);
            }else {
                currentCtrl.val(oldText);
                if(tj.hasRelationField == true) {  //做数据关联处理
                    if(form == undefined || typeof form == "undefined" || form == null) {
                        //doNoting
                    }else {
                        selectOrgPreCallBack(tj);//选人在选之前要调该表单组的接口
                        checkCallbackValueMap.put("returnValue",oldValue);
                        checkCallbackValueMap.put("displayValue",oldText);
                        selectOrg.handleRelationMemberData(null,tj,-1,checkCallbackValueMap); //初始化处理有默认回填值的情况的数据关联
                    }
                }
            }
        }else if(!oldValue || oldValue.length == 0 || oldValue == ""){
            returnValueCtrl.val("");
            if(isMulti) {
                currentCtrl.text("");
            }else {
                currentCtrl.val("");
            }
        }

        currentCtrl.unbind("click").bind("click",function() {
            $(this).blur();
            selectOrg.selectOrg();

        });
    }
    /**
     * 选日历
     * @param tj
     */
    MFormCompRenderBridge.bindSelectCalendar = function(tj) {
        var currentCtrl = tj.srcElement;
        currentCtrl.removeAttr("onblur").addClass("triangle");
        var initVal = currentCtrl.val();
        currentCtrl.attr("oldVal",initVal);
        var id = currentCtrl.attr("id");
        var fieldSpan = currentCtrl.parent("span[id$=_span]");
        var fieldVal = $.parseJSON(fieldSpan.attr("fieldval"));
        var inputType = fieldVal.inputType;
        var dateConfig = {
            date : {
                preset : 'date',
                minDate: new Date(1970,3,10,9,22),
                maxDate: new Date(2050,7,30,15,44)
            },
            datetime : {
                preset : 'datetime',
                minDate: new Date(1970,3,10,9,22),
                maxDate: new Date(2050,7,30,15,44)
            }
        };
        var calendarOptions = $.extend(
            dateConfig[inputType],
            {
                theme : 'default',//直接用该主题
                mode : 'scroller',//直接选用日期滚动的模式
                display : 'bottom',//直接选用从底部弹出的方式
                lang : (MFormConfig.language == 'en') ? '' : 'zh',//设置语言环境
                okCallback : function(formatDate) {
                    var oldVal = currentCtrl.attr("oldVal");
                    currentCtrl.val(formatDate);
                    if(oldVal != formatDate) {
                        calc(currentCtrl);
                    }
                    currentCtrl.attr("oldVal",formatDate);
                },
                clearCallback : function() {
                    currentCtrl.val("");
                    currentCtrl.attr("oldVal","");
                    calc(currentCtrl);
                }
            }
        );
        setTimeout(function(){
            currentCtrl.mobiscroll(calendarOptions);
        },300);

    }

    /**
     * 附件上传
     * @param tj
     */
    MFormCompRenderBridge.bindFileUpload = function(tj) {
        //很奇怪的一个地方，需要在页面添加一个ID为attachmentArea的Div
        var attachmentArea = '<div id="attachmentArea" style="overflow: auto;" requrl="/seeyon/fileUpload.do?type=0&applicationCategory=1&extensions=&maxSize=&isEncrypt=&popupTitleKey=&attachmentTrId="></div>';
//        if($("#cmp_common_wrapper").length > 0) {
//            if($("#cmp_common_wrapper").find("div[id=attachmentArea]").length == 0) {
//                $("#cmp_common_wrapper").append(attachmentArea);
//            }
//        }
        if($(document.body).find("div[id=attachmentArea]").length == 0) {  //因为在seework的流程表单里没有cmp_common_wrapper，所以兼容就在body里面填加
            $(document.body).append(attachmentArea);
        }
        var compDiv = $(tj.srcElement);
        var currentCtrl =  (compDiv.next("span").length > 0) ? compDiv.next("span") : compDiv.prev("span");//根据表单div结构来暂时判断此为点击按钮
        if(currentCtrl.length == 0) return;//在流程表单中有两个不需要初始化的隐藏file组件
        currentCtrl.css("position","relative").css("float","left");
        //干掉老是有一个在这个控件上的一点击方法
        var clickFun = currentCtrl.attr("onclick");
        if(typeof clickFun != "undefined"){
        	currentCtrl.attr("onclick","");
        }
        var ctrlWidth = currentCtrl.width();
        var ctrlHeight = currentCtrl.height();
        var uuid = MUUID.uuid();
        var fileInput = $("<input type='file'  name='file"+uuid+"' id='file"+uuid+"'" +
            "class='insertPic_hiddenUploadFileCtrl'> style='width:"+ctrlWidth+";height:"+ctrlHeight+"'");//创建一个透明的file按钮
        fileInput.appendTo(currentCtrl);
        var attsdata = $(tj.srcElement).attr("attsdata");
        var parent = $(tj.srcElement).parent();
        var str = parent.attr("fieldval");
        var obj = $.parseJSON(str);
        var inputType = obj ? obj.inputType : undefined;

        var isImageWidget = (inputType == "image") ? true : false;
        var uploadOptions = {
            displayWidth : tj.displayWidth,
            displayHeight : tj.displayHeight,
            loadingCallback : tj.loadingCallback,
            loadedCallback : tj.loadedCallback,
            failedCallback : tj.failedCallback,
            delCallback : tj.delCallback,
            backfillCallback : tj.backfillCallback,
            ctrl : currentCtrl,
            fileInput : fileInput,
            isImageWidget : isImageWidget,
            attsdata : attsdata
        }
        var formUploadFile = new form_uploadFile(tj,uploadOptions);
            currentCtrl.unbind("click").bind("click",function() {
                if(formUploadFile.checkFile(tj)) {
                    formUploadFile.chooseFile(tj);
                }

            });

    }
    /**
     * 追加组件
     * @param tj
     */
    MFormCompRenderBridge.bindAppendsText = function(tj) {
        var targetObj = $(tj);
        var validateObj;
        var maxLength;
        var chineseRegex = /[^\x00-\xff]/g;
        try{
            validateObj = $.parseJSON("{"+targetObj.attr("validate")+"}");
            maxLength = parseInt(validateObj.maxLength);
            var userFormatName = "[" + MFormConfig.currentUser + " " + new Date().format('yyyy-MM-dd hh:mm') + "]";
            var initMaxLength = userFormatName.replace(chineseRegex,"***").length;
            maxLength = maxLength - initMaxLength;
        }catch(e) {

        }
        var appendsTextOptions = {
            maxLength : maxLength
        }
        var formAppendsText = new form_appendsText(targetObj,appendsTextOptions);
        formAppendsText.showAppendsTextWidget();

    }
    /**
     * 关联文档
     * @param tj
     */
    MFormCompRenderBridge.bindAssociateDocument = function(tj) {
        var compDiv = $(tj.srcElement);
        var currentCtrl =  (compDiv.next("span").length > 0) ? compDiv.next("span") : compDiv.prev("span");//根据表单div结构来暂时判断此为点击按钮
        currentCtrl.css("float","left");
        var attsdata = $(tj.srcElement).attr("attsdata");
        var fieldSpan = currentCtrl.parent("span[id$=_span]");
        var fieldVal = $.parseJSON(fieldSpan.attr("fieldval"));
        var toRelationType = fieldVal.toRelationType;
        var isRelation = (toRelationType && toRelationType == "form_relation_field") ? true : false;
        if(!isRelation) { //需要将是否是关联表单的东西剔除出来
            var clickFun = currentCtrl.attr("onclick");
            if(typeof clickFun != "undefined"){
                currentCtrl.attr("onclick","");
            }
        }
        var assDocOptions = {
            choosedCallback : tj.choosedCallback,
            delCallback : tj.delCallback,
            backfillCallback : tj.backfillCallback,
            attsdata : attsdata
        }
        var formAssDoc = new form_assDoc(tj,assDocOptions);
        currentCtrl.unbind("click").bind("click",function() {
            $(this).blur();
            if(!isRelation) {  //是关联文档
                formAssDoc.createAssDocList(tj);
            }

        });
    }
    /**
     * 关联表单（搜索功能还没有完善）
     * @param ctrl：按钮
     */
    MFormCompRenderBridge.bindAssociateForm = function(ctrl) {
        if($(ctrl).attr("toFormDel") == "true") {
            $.alert("关联表单已被删除，请重新设置");
            return ;
        }
        var templateSize = $(ctrl).attr("templateSize");
        if(templateSize != undefined && templateSize <= 0) {
            var formName = $(this).attr("formName");
            $.alert("表单" + formName + "还没有建应用绑定");
            return ;
        }

        var recodeID = getRecordIdByJqueryField($(ctrl)); //调用pc接口获取表单关联的ID
        var formType = $(ctrl).attr("formType");
        var contentDataId = $("#contentDataId").val();
        var relation = $(ctrl).attr("relation");
        var fieldName = $(ctrl).attr("name");
        var relationParams = {
            relation : relation,
            recodeID : recodeID,
            contentDataID : contentDataId,
            formType : formType,
            fieldName : fieldName
        }
        var formAssForm = new form_assForm();
        //需要表单预提交
        preSubmitData(function () {//调用PC的接口
            formAssForm.showAssDocRelationList(relationParams);
        },function(){},false,false);

    }
    /**
     * 数字输入
     * @param tj
     */
    MFormCompRenderBridge.bindOnlyNumber = function(tj) {
        var compInput = $(tj.srcElement);
        compInput.removeAttr("onblur");
        if(compInput[0] && compInput[0].nodeName  && compInput[0].nodeName.toUpperCase() == "INPUT"){
            if(compInput.prop("type")=="text"){
                var compParent = compInput.parent();  //获取父节点去判断该输入域作何处理
                var fieldval = compParent.attr("fieldval");
                var fieldValObj = $.parseJSON(fieldval);
                var fieldType = fieldValObj.fieldType;
                var formatType = fieldValObj.formatType;

                var onlyNumberOptions = {
                    fieldType : fieldType,
                    formatType : formatType,
                    decimalDigit : tj.decimalDigit
                }
                var formOnlyNumber = new form_onlyNum(tj,onlyNumberOptions);

            }
        }

    }
    //桥接地图
    MFormCompRenderBridge.bindMap = function(tj) {
        var compInput = $(tj.srcElement);
        compInput.removeAttr("onblur");
        var miniType = tj.miniType;
        var compID = compInput.attr("id");
        compInput.attr("id",compID + "_txt").attr("name",compID + "_txt").addClass("triangle");
        var saveValueInput = $('<input type="hidden" id="'+compID+'" name="'+compID+'" style="display:none;">');
        if(tj.value && tj.value != "-1") {
            saveValueInput.val(tj.value);
            compInput.val(tj.text);
        }
        compInput.after(saveValueInput);
        var formMap = new form_map(tj);
        if(tj.canEdit == true || tj.canEdit == 'true') {
            compInput.unbind("click").bind("click",{param:tj},function(event) {
                $(this).blur();
                if(miniType == 1 || miniType == '1') {
                    formMap.openMapWidget();
                }else if(miniType == 3 || miniType == '3') {
                    formMap.mapLacate();
                }

            });
        }

    }

    var muiCard = '<div class="mui-card">' +
        '   <div class="mui-input-group"></div>' +
        '</div>';//mui输入组（卡片式）
    var muiRadioItemContainer = '<div class="mui-input-row mui-radio mui-left"></div>';//单选按钮容器（图标左对齐）
    var muiCheckboxItem = '<span></span><div class="mui-switch mui-switch-mini"><div class="mui-switch-handle"></div></div>';//复选按钮容器（图标左对齐）
    var simulateSelectBox = '<button  class="mui-btn mui-btn-block" type="button" style="padding: 5px 0;font-size: 15px;" ></button>';//模拟select的按钮

    //初始化单选按钮组
    MFormCompRenderBridge.bindRadio = function(t) {
        var card = $(muiCard);
        var inputGroup = card.find("div.mui-input-group");
        t.find("label").each(function() {
            $(this).removeAttr("class").removeAttr("style");
            var radioContainer = $(muiRadioItemContainer);
            $(this).appendTo(radioContainer);
            inputGroup.append(radioContainer);
        });
        t.append(card);
    }
    //初始化复选框按钮
    MFormCompRenderBridge.bindCheckbox = function(t) {
        var checkbox = $(muiCheckboxItem);
        var checkboxContainer = $("<div style='float: right;'></div>");
        checkbox.appendTo(checkboxContainer);
        var input = t.find("input[type=checkbox]");
        var isInitChecked = (input[0].checked == true)?true : false;
        input.css("display","none");
        t.append(checkboxContainer);
        var muiCheckbox = t.find("div.mui-switch");
        if(isInitChecked) muiCheckbox.addClass("mui-active");
        if(input[0].disabled == true) muiCheckbox.addClass("mui-disabled");//如果是disabled 就不能点击了
        muiCheckbox.unbind("toggle").bind("toggle",function() {
            if($(this).hasClass("mui-active")) {
                input[0].checked = true;
                input[0].value = 1;
            }else {
                input[0].checked = false;
                input[0].value = 0;
            }
            calc(input);//调用pc接口
        });
    }
    //初始化select
    MFormCompRenderBridge.bindSelect = function(t) {
        var select = t;
        var selectSpan = select.parent("span[id$=_span]");
        //做初始化的显示
        select.css("display","none");
        var options = select.children("option");
        var selectedOption = select.find(":selected");
        var selectedText =selectedOption.text();
        var selectedVal = selectedOption.val();
        selectedText = (selectedVal == "" || selectedText.length == 0 || typeof selectedVal == "undefined") ? '---请选择---':selectedText;
        var selectBox = $(simulateSelectBox);
        selectBox.text(selectedText);
        selectSpan.append(selectBox);
        if(select[0].disabled == true) {
            selectBox.addClass("mui-disabled");
            return;
        };
        var newSelect = new form_select(select,options,selectBox);
        selectBox.unbind("click").bind("click",function() {
            var beforeChangeVal = select.children(":selected").val();
            newSelect.change(function(selectedVal) {
                if(beforeChangeVal != selectedVal) {
                    calc(select);//调用pc接口
                }
            });
        });
        select.html(selectedOption);//将被选中的option插入
    }
    /**
     * 定义通用的组件，如：全屏的上传进度条等
     * @param commonType:通用组件类型（1，全屏上传的透明黑底遮蔽层）
     * @param iconClass：图片class名
     * @param title：标题
     * @param content：内容
     * @returns {string}
     */
    MFormCompRenderBridge.commonWidget = function(commonType,iconClass,title,content){
        var result = "";
        switch (commonType){
            case  MFormCommonWidgetConstant.C_iCommonWidgetName_fullScreenLoadingShieldLayer:
               result = $('<div class="cmp_loading_withShieldLayer">' +
                   '   <div class="tipsBox">' +
                   '       <div class="tipsContent"></div>'+
                   '           <span class="'+iconClass+'"></span>'+
                   '           <span class="text">'+content+'</span>'+
                   '   </div>'+
                   '</div>') ;
                break;
            case MFormCommonWidgetConstant.C_iCommonWidgetName_loadingWithNoShieldLayer:
                result = $('<div class="cmp_loading_withNoShieldLayer">' +
                    '   <div class="tipsBox">' +
                    '       <div class="tipsContent">' +
                    '           <span class="'+iconClass+'"></span>' +
                    '           <span class="text">'+content+'</span>' +
                    '       </div>' +
                    '   </div>' +
                    '</div>');
                break;
            default :
                break;
        }

        return result;
    }

    return MFormCompRenderBridge;
})();
//MFormCompRenderBridge e
//MFormCompInitPlugins.js s
/**
 * 表单组件初始化，完成所有表单组件渲染
 */
(function($){

    $.fn.comp = function(options) {
        var thisInsertValID = this.attr("id");
        var compInputID = thisInsertValID.replace("_span","");
        var compInput = (this.find("input[id="+compInputID+"]").length > 0) ? this.find("input[id="+compInputID+"]") : this.find("div.comp");
        compInput.compThis();
    };

    $.fn.compThis = function() {
        var t = this;
        var tc = t.attr("comp");
        if (tc) {
            tj = $.parseJSON('{' + tc + '}');
        }

        tp = tj.type;
        t.attr("compType", tp);
        tj.srcElement = t;
        switch (tp) {
            case 'onlyNumber':
                MFormCompRenderBridge.bindOnlyNumber(tj);
                break;
            case 'calendar':
                MFormCompRenderBridge.bindSelectCalendar(tj);
                break;
            case 'selectPeople':
                MFormCompRenderBridge.bindSelectOrg(tj);
                break;
            case 'correlation_form':
                //showInput(t, tp, tj);
                break;
            case 'assdoc':
                MFormCompRenderBridge.bindAssociateDocument(tj);
                break;
            case 'fileupload':
                MFormCompRenderBridge.bindFileUpload(tj);
                break;
            case 'correlation_project':
                //showInput(t, tp, tj);
                break;
            case 'data_task':
                //showInput(t, tp, tj);
                break;
            case 'search':
                //showInput(t, tp, tj);
                break;
            case 'chooseProject':
                //t.chooseProject(tj);
                break;
            case 'map':
                MFormCompRenderBridge.bindMap(tj);
                break;
            case 'autocomplete' :
                if(t.prop("tagName").toLocaleLowerCase() == 'select') {
                    MFormCompRenderBridge.bindSelect(t);
                }
                break;
            default :
                break;
        }
    };

    $.fn.comp4Common = function() {
        var t = this;
        var compDiv = t.children(".comp");
        if(compDiv.length > 0) return; //如果有comp属性的控件不进行初始话
        var fieldVal = t.attr("fieldval");
        var fieldValObj = null;
        if(fieldVal) {
            fieldValObj = $.parseJSON(fieldVal);
        }
        var inputType = fieldValObj.inputType;
        switch (inputType) {
            case 'radio' :
                MFormCompRenderBridge.bindRadio(t);
                break;
            case 'checkbox' :
                MFormCompRenderBridge.bindCheckbox(t);
                break;
            default :
                break;
        }
    }
})($);



/*===========================页面调用方法==============================*/
//追加组件
var addarea = function(targetArea) {
    $(targetArea).removeAttr("onblur");
    $(targetArea).blur();
    MFormCompRenderBridge.bindAppendsText(targetArea);

}
//关联表单
var showRelationList = function(targetCtrl) {
    if($(document).find("div.accDocWidget_assFormWidget").length == 0) {//绑定在dom上的click事件在三星手机上是点击两次，在此作判断避免重复请求数据
        MFormCompRenderBridge.bindAssociateForm(targetCtrl);
    }

}
//初始化普通控件样式
var initCommonControl4Mobile = function() {
    $("span[id$=_span]").each(function() {
        $(this).comp4Common();
    });
}

/*===============替换掉原来PC端的绑定在dom上的方法=============*/

var __addarea = addarea;
var __showRelationList = showRelationList;
$(function(){
    _mainBodyDiv = $("#mainbodyDiv");
    window.addarea = __addarea;
    window.showRelationList = __showRelationList;
    initFieldVoluation4Mobile(false);
    initCommonControl4Mobile();
});

/*================复写表单组在移动端没有加载进的函数和修改符合移动端的=========*/
(function($){
    var ctpEventIntercept = {};
    $.ctp = {
        bind: function (A, C) {
            var B = ctpEventIntercept.eventName;
            if (!Boolean(B)) {
                B = [];
                B.push(C);
                ctpEventIntercept.eventName = B
            } else {
                B.push(C)
            }    },
        trigger: function (A) {
            var C = ctpEventIntercept.eventName;
            if (Boolean(C)) {
                for (var B = 0; B < C.length; B++) {
                    if (!C[B]) {
                        return false
                    }
                }
            } else {
                return true
            }
    }};
})(jQuery);



//重写符合移动端的field的初始化oldval属性
function initFieldVoluation4Mobile(isPrint) {

    var sps;
    if(isPrint){
        sps = $("span[id$='_span']",$("#context"));
    }else{
        sps = $("span[id$='_span']",_mainBodyDiv);
    }
    for(var i=0;i<sps.length;i++){
        var jqueryField = $(sps[i]);
        var compInput = jqueryField.find(".comp");
        var comp = "";
        if(compInput.length > 0) {
            comp = jqueryField.attr("comp");
        }
        var compObj = (typeof comp == "undefined" || comp.length == 0) ? "" : $.parseJSON("{"+comp+"}");
        if(compObj != "") {
            if(compObj.type == "selectPeople" || compObj.type == "calendar" || compObj.type == "map" || compObj.type == "onlyNumber") {
                //doNothing   // 弹出式的组件不需要在此对oldval做处理，
            }else {
                initFieldOldval(jqueryField);
            }
        }else {
            if(jqueryField.attr("onclick") == "addarea(this)"){
                //doNothing  //追加组件也不需要在此对oldval做处理
            }else {
                initFieldOldval(jqueryField);
            }
        }

    }

}

function initFieldOldval(jqueryField) {
    var idStr = jqueryField.attr("id").split("_")[0];
    jqueryField.find("input[type='text']").each(function() {
        var textInput = $(this);
        if(textInput.attr("id") == idStr) {
            textInput.unbind("focus").bind("focus",function() {
                $(this).attr("oldVal",$(this).val());
            });
        }
    });
}
//MFormCompInitPlugins.js e