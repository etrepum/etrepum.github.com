(function ($) {
    var load_syntaxHighlighter = function () {
        var regex = /([^ ]+) literal-block/;
        $('pre.literal-block').each(function (idx, node) {
            node.className = node.className.replace(regex, ';brush: $1'
                ).replace(/\blight /, ';light: true');
        });
        var scripts_path = '/assets/js/syntaxhighlighter_3.0.83/scripts/';
        var script_list = [
            'applescript            @shBrushAppleScript.js',
            'actionscript3 as3      @shBrushAS3.js',
            'bash shell             @shBrushBash.js',
            'coldfusion cf          @shBrushColdFusion.js',
            'cpp c                  @shBrushCpp.js',
            'c# c-sharp csharp      @shBrushCSharp.js',
            'css                    @shBrushCss.js',
            'delphi pascal          @shBrushDelphi.js',
            'diff patch pas         @shBrushDiff.js',
            'erl erlang             @shBrushErlang.js',
            'hs haskell             @shBrushHaskell.js',
            'groovy                 @shBrushGroovy.js',
            'java                   @shBrushJava.js',
            'jfx javafx             @shBrushJavaFX.js',
            'js jscript javascript  @shBrushJScript.js',
            'perl pl                @shBrushPerl.js',
            'php                    @shBrushPhp.js',
            'text plain             @shBrushPlain.js',
            'py python              @shBrushPython.js',
            'ruby rails ror rb      @shBrushRuby.js',
            'sass scss              @shBrushSass.js',
            'scala                  @shBrushScala.js',
            'sql                    @shBrushSql.js',
            'vb vbnet               @shBrushVb.js',
            'xml xhtml xslt html    @shBrushXml.js'
            ].map(function (n) { return n.replace("@", scripts_path); });
        function gs(fn, f) {
            $.ajax(scripts_path + fn, {
                cache: true,
                dataType: 'script',
                complete: f
            });
        }
        gs('shCore.js', function () {
            gs('shAutoloader.js', function () {
                SyntaxHighlighter.defaults.toolbar = false;
                SyntaxHighlighter.autoloader.apply(null, script_list);
                SyntaxHighlighter.all();
            });
        });
    };
    load_syntaxHighlighter();
})(jQuery);