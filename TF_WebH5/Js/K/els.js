/**
 * ESL (Enterprise Standard Loader)
 * Copyright 2013 Baidu Inc. All rights reserved.
 * 
 * @file Browser绔爣鍑嗗姞杞藉櫒锛岀鍚圓MD瑙勮寖
 * @author errorrik(errorrik@gmail.com)
 *         Firede(firede@firede.us)
 */

var define;
var require;

(function (global) {
    // "mod"寮€澶寸殑鍙橀噺鎴栧嚱鏁颁负鍐呴儴妯″潡绠＄悊鍑芥暟
    // 涓烘彁楂樺帇缂╃巼锛屼笉浣跨敤function鎴杘bject鍖呰

    /**
     * 妯″潡瀹瑰櫒
     * 
     * @inner
     * @type {Object}
     */
    var modModules = {};

    var MODULE_STATE_PRE_DEFINED = 1;
    var MODULE_STATE_PRE_ANALYZED = 2;
    var MODULE_STATE_ANALYZED = 3;
    var MODULE_STATE_READY = 4;
    var MODULE_STATE_DEFINED = 5;

    /**
     * 鍏ㄥ眬require鍑芥暟
     * 
     * @inner
     * @type {Function}
     */
    var actualGlobalRequire = createLocalRequire('');

    /**
     * 瓒呮椂鎻愰啋瀹氭椂鍣�
     * 
     * @inner
     * @type {number}
     */
    var waitTimeout;

    /**
     * 鍔犺浇妯″潡
     * 
     * @param {string|Array} requireId 妯″潡id鎴栨ā鍧梚d鏁扮粍锛�
     * @param {Function=} callback 鍔犺浇瀹屾垚鐨勫洖璋冨嚱鏁�
     * @return {*}
     */
    function require(requireId, callback) {
        assertNotContainRelativeId(requireId);

        // 瓒呮椂鎻愰啋
        var timeout = requireConf.waitSeconds;
        if (isArray(requireId) && timeout) {
            if (waitTimeout) {
                clearTimeout(waitTimeout);
            }
            waitTimeout = setTimeout(waitTimeoutNotice, timeout * 1000);
        }

        return actualGlobalRequire(requireId, callback);
    }

    /**
     * 灏嗘ā鍧楁爣璇嗚浆鎹㈡垚鐩稿鐨剈rl
     * 
     * @param {string} id 妯″潡鏍囪瘑
     * @return {string}
     */
    require.toUrl = toUrl;

    /**
     * 瓒呮椂鎻愰啋鍑芥暟
     * 
     * @inner
     */
    function waitTimeoutNotice() {
        var hangModules = [];
        var missModules = [];
        var missModulesMap = {};
        var hasError;

        for (var id in modModules) {
            if (!modIsDefined(id)) {
                hangModules.push(id);
                hasError = 1;
            }

            each(
                modModules[id].realDeps || [],
                function (depId) {
                    if (!modModules[depId] && !missModulesMap[depId]) {
                        hasError = 1;
                        missModules.push(depId);
                        missModulesMap[depId] = 1;
                    }
                }
            );
        }

        if (hasError) {
            throw new Error('[MODULE_TIMEOUT]Hang( '
                + (hangModules.join(', ') || 'none')
                + ' ) Miss( '
                + (missModules.join(', ') || 'none')
                + ' )'
            );
        }
    }

    /**
     * 灏濊瘯瀹屾垚妯″潡瀹氫箟鐨勫畾鏃跺櫒
     * 
     * @inner
     * @type {number}
     */
    var tryDefineTimeout;

    /**
     * 瀹氫箟妯″潡
     * 
     * @param {string=} id 妯″潡鏍囪瘑
     * @param {Array=} dependencies 渚濊禆妯″潡鍒楄〃
     * @param {Function=} factory 鍒涘缓妯″潡鐨勫伐鍘傛柟娉�
     */
    function define() {
        var argsLen = arguments.length;
        if (!argsLen) {
            return;
        }

        var id;
        var dependencies;
        var factory = arguments[--argsLen];

        while (argsLen--) {
            var arg = arguments[argsLen];

            if (isString(arg)) {
                id = arg;
            }
            else if (isArray(arg)) {
                dependencies = arg;
            }
        }

        // 鍑虹幇window涓嶆槸鐤忓拷
        // esl璁捐鏄仛涓篵rowser绔殑loader
        // 闂寘鐨刧lobal鏇村鎰忎箟鍦ㄤ簬锛�
        //     define鍜宺equire鏂规硶鍙互琚寕鍒扮敤鎴疯嚜瀹氫箟瀵硅薄涓�
        var opera = window.opera;

        // IE涓嬮€氳繃current script鐨刣ata-require-id鑾峰彇褰撳墠id
        if (
            !id
            && document.attachEvent
            && (!(opera && opera.toString() === '[object Opera]'))
        ) {
            var currentScript = getCurrentScript();
            id = currentScript && currentScript.getAttribute('data-require-id');
        }

        // 澶勭悊渚濊禆澹版槑
        // 榛樿涓篬'require', 'exports', 'module']
        dependencies = dependencies || ['require', 'exports', 'module'];
        if (id) {
            modPreDefine(id, dependencies, factory);

            // 鍦ㄤ笉杩滅殑鏈潵灏濊瘯瀹屾垚define
            // define鍙兘鏄湪椤甸潰涓煇涓湴鏂硅皟鐢紝涓嶄竴瀹氭槸鍦ㄧ嫭绔嬬殑鏂囦欢琚玶equire瑁呰浇
            if (tryDefineTimeout) {
                clearTimeout(tryDefineTimeout);
            }
            tryDefineTimeout = setTimeout(modPreAnalyse, 10);
        }
        else {
            // 绾綍鍒板叡浜彉閲忎腑锛屽湪load鎴杛eadystatechange涓鐞�
            wait4PreDefines.push({
                deps: dependencies,
                factory: factory
            });
        }
    }

    define.amd = {};

    /**
     * 鑾峰彇鐩稿簲鐘舵€佺殑妯″潡鍒楄〃
     * 
     * @inner
     * @param {number} state 鐘舵€佺爜
     * @return {Array}
     */
    function modGetByState(state) {
        var modules = [];
        for (var key in modModules) {
            var module = modModules[key];
            if (module.state == state) {
                modules.push(module);
            }
        }

        return modules;
    }

    /**
     * 妯″潡閰嶇疆鑾峰彇鍑芥暟
     * 
     * @inner
     * @return {Object} 妯″潡閰嶇疆瀵硅薄
     */
    function moduleConfigGetter() {
        var conf = requireConf.config[this.id];
        if (conf && typeof conf === 'object') {
            return conf;
        }

        return {};
    }

    /**
     * 棰勫畾涔夋ā鍧�
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @param {Array.<string>} dependencies 鏄惧紡澹版槑鐨勪緷璧栨ā鍧楀垪琛�
     * @param {*} factory 妯″潡瀹氫箟鍑芥暟鎴栨ā鍧楀璞�
     */
    function modPreDefine(id, dependencies, factory) {
        if (modExists(id)) {
            return;
        }

        var module = {
            id: id,
            deps: dependencies,
            factory: factory,
            exports: {},
            config: moduleConfigGetter,
            state: MODULE_STATE_PRE_DEFINED,
            hardDeps: {}
        };

        // 灏嗘ā鍧楅瀛樺叆defining闆嗗悎涓�
        modModules[id] = module;
    }

    /**
     * 棰勫垎鏋愭ā鍧�
     * 
     * 棣栧厛锛屽畬鎴愬factory涓０鏄庝緷璧栫殑鍒嗘瀽鎻愬彇
     * 鐒跺悗锛屽皾璇曞姞杞�"璧勬簮鍔犺浇鎵€闇€妯″潡"
     * 
     * 闇€瑕佸厛鍔犺浇妯″潡鐨勫師鍥犳槸锛氬鏋滄ā鍧椾笉瀛樺湪锛屾棤娉曡繘琛宺esourceId normalize鍖�
     * modAnalyse瀹屾垚鍚庣画鐨勪緷璧栧垎鏋愬鐞嗭紝骞惰繘琛屼緷璧栨ā鍧楃殑鍔犺浇
     * 
     * @inner
     * @param {Object} modules 妯″潡瀵硅薄
     */
    function modPreAnalyse() {
        var pluginModuleIds = [];
        var pluginModuleIdsMap = {};
        var modules = modGetByState(MODULE_STATE_PRE_DEFINED);

        each(
            modules,
            function (module) {
                // 澶勭悊瀹為檯闇€瑕佸姞杞界殑渚濊禆
                var realDepends = module.deps.slice(0);
                module.realDeps = realDepends;

                // 鍒嗘瀽function body涓殑require
                // 濡傛灉鍖呭惈鏄惧紡渚濊禆澹版槑锛屼负鎬ц兘鑰冭檻锛屽彲浠ヤ笉鍒嗘瀽factoryBody
                // AMD瑙勮寖鐨勮鏄庢槸`SHOULD NOT`锛屾墍浠ヨ繖閲岃繕鏄垎鏋愪簡
                var factory = module.factory;
                var requireRule = /require\(\s*(['"'])([^'"]+)\1\s*\)/g;
                var commentRule = /(\/\*([\s\S]*?)\*\/|([^:]|^)\/\/(.*)$)/mg;
                if (isFunction(factory)) {
                    factory.toString()
                        .replace(commentRule, '')
                        .replace(requireRule, function ($0, $1, $2) {
                            realDepends.push($2);
                        });
                }

                // 鍒嗘瀽resource鍔犺浇鐨刾lugin module id
                each(
                    realDepends,
                    function (dependId) {
                        var idInfo = parseId(dependId);
                        if (idInfo.resource) {
                            var plugId = normalize(idInfo.module, module.id);
                            if (!pluginModuleIdsMap[plugId]) {
                                pluginModuleIds.push(plugId);
                                pluginModuleIdsMap[plugId] = 1;
                            }
                        }
                    }
                );

                module.state = MODULE_STATE_PRE_ANALYZED;
            }
        );

        nativeRequire(pluginModuleIds, function () {
            modAnalyse(modules);
        });
    }

    /**
     * 鍒嗘瀽妯″潡
     * 瀵规墍鏈変緷璧杋d杩涜normalize鍖栵紝瀹屾垚鍒嗘瀽锛屽苟灏濊瘯鍔犺浇鍏朵緷璧栫殑妯″潡
     * 
     * @inner
     * @param {Array} modules 妯″潡瀵硅薄鍒楄〃
     */
    function modAnalyse(modules) {
        var requireModules = [];

        each(
            modules,
            function (module) {
                if (module.state !== MODULE_STATE_PRE_ANALYZED) {
                    return;
                }

                var id = module.id;

                // 瀵瑰弬鏁颁腑澹版槑鐨勪緷璧栬繘琛宯ormalize
                var depends = module.deps;
                var hardDepends = module.hardDeps;
                var hardDependsCount = isFunction(module.factory)
                    ? module.factory.length
                    : 0;

                each(
                    depends,
                    function (dependId, index) {
                        dependId = normalize(dependId, id);
                        depends[index] = dependId;

                        if (index < hardDependsCount) {
                            hardDepends[dependId] = 1;
                        }
                    }
                );

                // 渚濊禆妯″潡id normalize鍖栵紝骞跺幓闄ゅ繀瑕佺殑渚濊禆銆傚幓闄ょ殑渚濊禆妯″潡鏈夛細
                // 1. 鍐呴儴妯″潡锛歳equire/exports/module
                // 2. 閲嶅妯″潡锛歞ependencies鍙傛暟鍜屽唴閮╮equire鍙兘閲嶅
                // 3. 绌烘ā鍧楋細dependencies涓娇鐢ㄨ€呭彲鑳藉啓绌�
                var realDepends = module.realDeps;
                var len = realDepends.length;
                var existsDepend = {};

                while (len--) {
                    // 姝ゅ鍜屼笂閮ㄥ垎寰幆瀛樺湪閲嶅normalize锛屽洜涓篸eps鍜宺ealDeps鏄噸澶嶇殑
                    // 涓轰繚鎸侀€昏緫鍒嗙晫娓呮櫚锛屽氨涓嶅仛浼樺寲浜嗗厛
                    var dependId = normalize(realDepends[len], id);
                    if (!dependId
                         || dependId in existsDepend
                         || dependId in BUILDIN_MODULE
                    ) {
                        realDepends.splice(len, 1);
                    }
                    else {
                        existsDepend[dependId] = 1;
                        realDepends[len] = dependId;

                        // 灏嗗疄闄呬緷璧栧帇鍏ュ姞杞藉簭鍒椾腑锛屽悗缁粺涓€杩涜require
                        requireModules.push(dependId);
                    }
                }

                module.realDepsIndex = existsDepend;
                module.state = MODULE_STATE_ANALYZED;

                modWaitDependenciesLoaded(module);
                modInvokeFactoryDependOn(id);
            }
        );

        nativeRequire(requireModules);
    }

    /**
     * 绛夊緟妯″潡渚濊禆鍔犺浇瀹屾垚
     * 鍔犺浇瀹屾垚鍚庡皾璇曡皟鐢╢actory瀹屾垚妯″潡瀹氫箟
     * 
     * @inner
     * @param {Object} module 妯″潡瀵硅薄
     */
    function modWaitDependenciesLoaded(module) {
        var id = module.id;

        module.invokeFactory = invokeFactory;
        invokeFactory();

        // 鐢ㄤ簬閬垮厤姝讳緷璧栭摼鐨勬寰幆灏濊瘯
        var checkingLevel = 0;

        /**
         * 鍒ゆ柇渚濊禆鍔犺浇瀹屾垚
         * 
         * @inner
         * @return {boolean}
         */
        function checkInvokeReadyState() {
            checkingLevel++;

            var isReady = 1;
            var tryDeps = [];

            each(
                module.realDeps,
                function (depId) {
                    if (!modIsAnalyzed(depId)) {
                        isReady = 0;
                    }
                    else if (!modIsDefined(depId)) {
                        switch (modHasCircularDependency(id, depId)) {
                            case CIRCULAR_DEP_UNREADY:
                            case CIRCULAR_DEP_NO:
                                isReady = 0;
                                break;
                            case CIRCULAR_DEP_YES:
                                if (module.hardDeps[depId]) {
                                    tryDeps.push(depId);
                                }
                                break;
                        }
                    }

                    return !!isReady;
                }
            );


            // 鍙湁褰撳叾浠栭潪寰幆渚濊禆閮借杞戒簡锛屾墠鍘诲皾璇曡Е鍙戠‖渚濊禆妯″潡鐨勫垵濮嬪寲
            isReady && each(
                tryDeps,
                function (depId) {
                    modTryInvokeFactory(depId);
                }
            );

            isReady = isReady && tryDeps.length === 0;
            isReady && (module.state = MODULE_STATE_READY);

            checkingLevel--;
            return isReady;
        }

        /**
         * 鍒濆鍖栨ā鍧�
         * 
         * @inner
         */
        function invokeFactory() {
            if (module.state == MODULE_STATE_DEFINED
                || checkingLevel > 1
                || !checkInvokeReadyState()
            ) {
                return;
            }

            // 璋冪敤factory鍑芥暟鍒濆鍖杕odule
            try {
                var factory = module.factory;
                var exports = isFunction(factory)
                    ? factory.apply(
                        global,
                        modGetModulesExports(
                            module.deps,
                            {
                                require: createLocalRequire(id),
                                exports: module.exports,
                                module: module
                            }
                        )
                    )
                    : factory;

                if (typeof exports != 'undefined') {
                    module.exports = exports;
                }

                module.state = MODULE_STATE_DEFINED;
                module.invokeFactory = null;
            }
            catch (ex) {
                if (/^\[MODULE_MISS\]"([^"]+)/.test(ex.message)) {
                    // 鍑洪敊璇存槑鍦╢actory鐨勮繍琛屼腑锛岃require鐨勬ā鍧楁槸闇€瑕佺殑
                    // 鎵€浠ユ妸瀹冨姞鍏ョ‖渚濊禆涓�
                    module.hardDeps[RegExp.$1] = 1;
                    return;
                }

                throw ex;
            }


            modInvokeFactoryDependOn(id);
            modFireDefined(id);
        }
    }

    /**
     * 鏍规嵁妯″潡id鏁扮粍锛岃幏鍙栧叾鐨別xports鏁扮粍
     * 鐢ㄤ簬妯″潡鍒濆鍖栫殑factory鍙傛暟鎴杛equire鐨刢allback鍙傛暟鐢熸垚
     * 
     * @inner
     * @param {Array} modules 妯″潡id鏁扮粍
     * @param {Object} buildinModules 鍐呭缓妯″潡瀵硅薄
     * @return {Array}
     */
    function modGetModulesExports(modules, buildinModules) {
        var args = [];
        each(
            modules,
            function (moduleId, index) {
                args[index] =
                    buildinModules[moduleId]
                    || modGetModuleExports(moduleId);
            }
        );

        return args;
    }

    var CIRCULAR_DEP_UNREADY = 0;
    var CIRCULAR_DEP_NO = 1;
    var CIRCULAR_DEP_YES = 2;

    /**
     * 鍒ゆ柇source鏄惁澶勪簬target鐨勪緷璧栭摼涓�
     *
     * @inner
     * @return {number}
     */
    function modHasCircularDependency(source, target, meet) {
        if (!modIsAnalyzed(target)) {
            return CIRCULAR_DEP_UNREADY;
        }

        meet = meet || {};
        meet[target] = 1;

        if (target == source) {
            return CIRCULAR_DEP_YES;
        }

        var module = modGetModule(target);
        var depends = module && module.realDeps;


        if (depends) {
            var len = depends.length;

            while (len--) {
                var dependId = depends[len];
                if (meet[dependId]) {
                    continue;
                }

                var state = modHasCircularDependency(source, dependId, meet);
                switch (state) {
                    case CIRCULAR_DEP_UNREADY:
                    case CIRCULAR_DEP_YES:
                        return state;
                }
            }
        }

        return CIRCULAR_DEP_NO;
    }

    /**
     * 璁╀緷璧栬嚜宸辩殑妯″潡灏濊瘯鍒濆鍖�
     * 
     * @inner
     * @param {string} id 妯″潡id
     */
    function modInvokeFactoryDependOn(id) {
        for (var key in modModules) {
            var realDeps = modModules[key].realDepsIndex || {};
            realDeps[id] && modTryInvokeFactory(key);
        }
    }

    /**
     * 灏濊瘯鎵ц妯″潡factory鍑芥暟锛岃繘琛屾ā鍧楀垵濮嬪寲
     * 
     * @inner
     * @param {string} id 妯″潡id
     */
    function modTryInvokeFactory(id) {
        var module = modModules[id];

        if (module && module.invokeFactory) {
            module.invokeFactory();
        }
    }

    /**
     * 妯″潡瀹氫箟瀹屾垚鐨勪簨浠剁洃鍚櫒
     * 
     * @inner
     * @type {Array}
     */
    var modDefinedListener = [];

    /**
     * 妯″潡瀹氫箟瀹屾垚浜嬩欢鐩戝惉鍣ㄧ殑绉婚櫎绱㈠紩
     * 
     * @inner
     * @type {Array}
     */
    var modRemoveListenerIndex = [];

    /**
     * 妯″潡瀹氫箟瀹屾垚浜嬩欢fire灞傜骇
     * 
     * @inner
     * @type {number}
     */
    var modFireLevel = 0;

    /**
     * 娲惧彂妯″潡瀹氫箟瀹屾垚浜嬩欢
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     */
    function modFireDefined(id) {
        modFireLevel++;
        each(
            modDefinedListener,
            function (listener) {
                listener && listener(id);
            }
        );
        modFireLevel--;

        modSweepDefinedListener();
    }

    /**
     * 娓呯悊妯″潡瀹氫箟瀹屾垚浜嬩欢鐩戝惉鍣�
     * modRemoveDefinedListener鏃跺彧鍋氭爣璁�
     * 鍦╩odFireDefined鎵ц娓呴櫎鍔ㄤ綔
     * 
     * @inner
     * @param {Function} listener 妯″潡瀹氫箟鐩戝惉鍣�
     */
    function modSweepDefinedListener() {
        if (modFireLevel < 1) {
            modRemoveListenerIndex.sort(
                function (a, b) { return b - a; }
            );

            each(
                modRemoveListenerIndex,
                function (index) {
                    modDefinedListener.splice(index, 1);
                }
            );

            modRemoveListenerIndex = [];
        }
    }

    /**
     * 绉婚櫎妯″潡瀹氫箟鐩戝惉鍣�
     * 
     * @inner
     * @param {Function} listener 妯″潡瀹氫箟鐩戝惉鍣�
     */
    function modRemoveDefinedListener(listener) {
        each(
            modDefinedListener,
            function (item, index) {
                if (listener == item) {
                    modRemoveListenerIndex.push(index);
                }
            }
        );
    }

    /**
     * 娣诲姞妯″潡瀹氫箟鐩戝惉鍣�
     * 
     * @inner
     * @param {Function} listener 妯″潡瀹氫箟鐩戝惉鍣�
     */
    function modAddDefinedListener(listener) {
        modDefinedListener.push(listener);
    }

    /**
     * 鍒ゆ柇妯″潡鏄惁瀛樺湪
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @return {boolean}
     */
    function modExists(id) {
        return id in modModules;
    }

    /**
     * 鍒ゆ柇妯″潡鏄惁宸插畾涔夊畬鎴�
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @return {boolean}
     */
    function modIsDefined(id) {
        return modExists(id)
            && modModules[id].state == MODULE_STATE_DEFINED;
    }

    /**
     * 鍒ゆ柇妯″潡鏄惁宸插垎鏋愬畬鎴�
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @return {boolean}
     */
    function modIsAnalyzed(id) {
        return modExists(id)
            && modModules[id].state >= MODULE_STATE_ANALYZED;
    }

    /**
     * 鑾峰彇妯″潡鐨別xports
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @return {*}
     */
    function modGetModuleExports(id) {
        if (modIsDefined(id)) {
            return modModules[id].exports;
        }

        return null;
    }

    /**
     * 鑾峰彇妯″潡
     * 
     * @inner
     * @param {string} id 妯″潡鏍囪瘑
     * @return {Object}
     */
    function modGetModule(id) {
        return modModules[id];
    }

    /**
     * 娣诲姞璧勬簮
     * 
     * @inner
     * @param {string} resourceId 璧勬簮鏍囪瘑
     * @param {*} value 璧勬簮瀵硅薄
     */
    function modAddResource(resourceId, value) {
        modModules[resourceId] = {
            exports: value || true,
            state: MODULE_STATE_DEFINED
        };

        modInvokeFactoryDependOn(resourceId);
        modFireDefined(resourceId);
    }

    /**
     * 鍐呭缓module鍚嶇О闆嗗悎
     * 
     * @inner
     * @type {Object}
     */
    var BUILDIN_MODULE = {
        require: require,
        exports: 1,
        module: 1
    };

    /**
     * 鏈瀹氫箟鐨勬ā鍧楅泦鍚�
     * 涓昏瀛樺偍鍖垮悕鏂瑰紡define鐨勬ā鍧�
     * 
     * @inner
     * @type {Array}
     */
    var wait4PreDefines = [];

    /**
     * 瀹屾垚妯″潡棰勫畾涔�
     * 
     * @inner
     */
    function completePreDefine(currentId) {
        var preDefines = wait4PreDefines.slice(0);

        wait4PreDefines.length = 0;
        wait4PreDefines = [];

        // 棰勫畾涔夋ā鍧楋細
        // 姝ゆ椂澶勭悊鐨勬ā鍧楅兘鏄尶鍚峝efine鐨勬ā鍧�
        each(
            preDefines,
            function (module) {
                var id = module.id || currentId;
                modPreDefine(id, module.deps, module.factory);
            }
        );

        modPreAnalyse();
    }

    /**
     * 鑾峰彇妯″潡
     * 
     * @param {string|Array} ids 妯″潡鍚嶇О鎴栨ā鍧楀悕绉板垪琛�
     * @param {Function=} callback 鑾峰彇妯″潡瀹屾垚鏃剁殑鍥炶皟鍑芥暟
     * @return {Object}
     */
    function nativeRequire(ids, callback, baseId) {
        callback = callback || new Function();
        baseId = baseId || '';

        // 鏍规嵁 https://github.com/amdjs/amdjs-api/wiki/require
        // It MUST throw an error if the module has not 
        // already been loaded and evaluated.
        if (isString(ids)) {
            if (!modIsDefined(ids)) {
                throw new Error('[MODULE_MISS]"' + ids + '" is not exists!');
            }

            return modGetModuleExports(ids);
        }

        if (!isArray(ids)) {
            return;
        }

        if (ids.length === 0) {
            callback();
            return;
        }

        var isCallbackCalled = 0;
        modAddDefinedListener(tryFinishRequire);
        each(
            ids,
            function (id) {
                if (id in BUILDIN_MODULE) {
                    return;
                }

                (id.indexOf('!') > 0
                    ? loadResource
                    : loadModule
                )(id, baseId);
            }
        );

        tryFinishRequire();

        /**
         * 灏濊瘯瀹屾垚require锛岃皟鐢╟allback
         * 鍦ㄦā鍧椾笌鍏朵緷璧栨ā鍧楅兘鍔犺浇瀹屾椂璋冪敤
         * 
         * @inner
         */
        function tryFinishRequire() {
            if (isCallbackCalled) {
                return;
            }

            var visitedModule = {};

            /**
             * 鍒ゆ柇鏄惁鎵€鏈夋ā鍧楅兘宸茬粡鍔犺浇瀹屾垚锛屽寘鎷叾渚濊禆鐨勬ā鍧�
             * 
             * @inner
             * @param {Array} modules 鐩存帴妯″潡鏍囪瘑鍒楄〃
             * @return {boolean}
             */
            function isAllInited(modules) {
                var allInited = 1;
                each(
                    modules,
                    function (id) {
                        if (visitedModule[id]) {
                            return;
                        }
                        visitedModule[id] = 1;

                        if (BUILDIN_MODULE[id]) {
                            return;
                        }

                        if (
                            !modIsDefined(id)
                            || !isAllInited(modGetModule(id).realDeps)
                        ) {
                            allInited = 0;
                            return false;
                        }
                    }
                );

                return allInited;
            }

            // 妫€娴嬪苟璋冪敤callback
            if (isAllInited(ids)) {
                isCallbackCalled = 1;
                modRemoveDefinedListener(tryFinishRequire);

                callback.apply(
                    global,
                    modGetModulesExports(ids, BUILDIN_MODULE)
                );
            }
        }
    }

    /**
     * 姝ｅ湪鍔犺浇鐨勬ā鍧楀垪琛�
     * 
     * @inner
     * @type {Object}
     */
    var loadingModules = {};

    /**
     * 鍔犺浇妯″潡
     * 
     * @inner
     * @param {string} moduleId 妯″潡鏍囪瘑
     */
    function loadModule(moduleId) {
        if (loadingModules[moduleId]) {
            return;
        }

        if (modExists(moduleId)) {
            modAnalyse([modGetModule(moduleId)]);
            return;
        }

        loadingModules[moduleId] = 1;

        // 鍒涘缓script鏍囩
        // 
        // 杩欓噷涓嶆寕鎺nerror鐨勯敊璇鐞�
        // 鍥犱负楂樼骇娴忚鍣ㄥ湪devtool鐨刢onsole闈㈡澘浼氭姤閿�
        // 鍐峵hrow涓€涓狤rror澶氭涓€涓句簡
        var script = document.createElement('script');
        script.setAttribute('data-require-id', moduleId);
        script.src = toUrl(moduleId);
        script.async = true;
        if (script.readyState) {
            script.onreadystatechange = loadedListener;
        }
        else {
            script.onload = loadedListener;
        }
        appendScript(script);

        /**
         * script鏍囩鍔犺浇瀹屾垚鐨勪簨浠跺鐞嗗嚱鏁�
         * 
         * @inner
         */
        function loadedListener() {
            var readyState = script.readyState;
            if (
                typeof readyState == 'undefined'
                || /^(loaded|complete)$/.test(readyState)
            ) {
                script.onload = script.onreadystatechange = null;
                script = null;

                completePreDefine(moduleId);
                delete loadingModules[moduleId];
            }
        }
    }

    /**
     * 鍔犺浇璧勬簮
     * 
     * @inner
     * @param {string} pluginAndResource 鎻掍欢涓庤祫婧愭爣璇�
     * @param {string} baseId 褰撳墠鐜鐨勬ā鍧楁爣璇�
     */
    function loadResource(pluginAndResource, baseId) {
        var idInfo = parseId(pluginAndResource);
        var pluginId = idInfo.module;
        var resourceId = idInfo.resource;

        /**
         * plugin鍔犺浇瀹屾垚鐨勫洖璋冨嚱鏁�
         * 
         * @inner
         * @param {*} value resource鐨勫€�
         */
        function pluginOnload(value) {
            modAddResource(pluginAndResource, value);
        }

        /**
         * 璇ユ柟娉曞厑璁竝lugin浣跨敤鍔犺浇鐨勮祫婧愬０鏄庢ā鍧�
         * 
         * @param {string} name 妯″潡id
         * @param {string} body 妯″潡澹版槑瀛楃涓�
         */
        pluginOnload.fromText = function (id, text) {
            new Function(text)();
            completePreDefine(id);
        };

        /**
         * 鍔犺浇璧勬簮
         * 
         * @inner
         * @param {Object} plugin 鐢ㄤ簬鍔犺浇璧勬簮鐨勬彃浠舵ā鍧�
         */
        function load(plugin) {
            if (!modIsDefined(pluginAndResource)) {
                plugin.load(
                    resourceId,
                    createLocalRequire(baseId),
                    pluginOnload,
                    moduleConfigGetter.call({ id: pluginAndResource })
                );
            }
        }

        if (!modIsDefined(pluginId)) {
            nativeRequire([pluginId], load);
        }
        else {
            load(modGetModuleExports(pluginId));
        }
    }

    /**
     * require閰嶇疆
     * 
     * @inner
     * @type {Object}
     */
    var requireConf = {
        baseUrl: './',
        paths: {},
        config: {},
        map: {},
        packages: [],
        waitSeconds: 0,
        urlArgs: {}
    };

    /**
     * 娣峰悎褰撳墠閰嶇疆椤逛笌鐢ㄦ埛浼犲叆鐨勯厤缃」
     * 
     * @inner
     * @param {string} name 閰嶇疆椤瑰悕绉�
     * @param {Any} value 鐢ㄦ埛浼犲叆閰嶇疆椤圭殑鍊�
     */
    function mixConfig(name, value) {
        var originValue = requireConf[name];
        var type = typeof originValue;
        if (type == 'string' || type == 'number') {
            requireConf[name] = value;
        }
        else if (isArray(originValue)) {
            each(value, function (item) {
                originValue.push(item);
            });
        }
        else {
            for (var key in value) {
                originValue[key] = value[key];
            }
        }
    }

    /**
     * 閰嶇疆require
     * 
     * @param {Object} conf 閰嶇疆瀵硅薄
     */
    require.config = function (conf) {
        // 绠€鍗曠殑澶氬閰嶇疆杩樻槸闇€瑕佹敮鎸�
        // 鎵€浠ュ疄鐜版洿鏀逛负浜岀骇mix
        for (var key in requireConf) {
            if (conf.hasOwnProperty(key)) {
                var confItem = conf[key];
                if (key == 'urlArgs' && isString(confItem)) {
                    defaultUrlArgs = confItem;
                }
                else {
                    mixConfig(key, confItem);
                }
            }
        }

        createConfIndex();
    };

    // 鍒濆鍖栨椂闇€瑕佸垱寤洪厤缃储寮�
    createConfIndex();

    /**
     * 鍒涘缓閰嶇疆淇℃伅鍐呴儴绱㈠紩
     * 
     * @inner
     */
    function createConfIndex() {
        requireConf.baseUrl = requireConf.baseUrl.replace(/\/$/, '') + '/';
        createPathsIndex();
        createMappingIdIndex();
        createPackagesIndex();
        createUrlArgsIndex();
    }

    /**
     * packages鍐呴儴绱㈠紩
     * 
     * @inner
     * @type {Array}
     */
    var packagesIndex;

    /**
     * 鍒涘缓packages鍐呴儴绱㈠紩
     * 
     * @inner
     */
    function createPackagesIndex() {
        packagesIndex = [];
        each(
            requireConf.packages,
            function (packageConf) {
                var pkg = packageConf;
                if (isString(packageConf)) {
                    pkg = {
                        name: packageConf.split('/')[0],
                        location: packageConf,
                        main: 'main'
                    };
                }

                pkg.location = pkg.location || pkg.name;
                pkg.main = (pkg.main || 'main').replace(/\.js$/i, '');
                packagesIndex.push(pkg);
            }
        );

        packagesIndex.sort(createDescSorter('name'));
    }

    /**
     * paths鍐呴儴绱㈠紩
     * 
     * @inner
     * @type {Array}
     */
    var pathsIndex;

    /**
     * 鍒涘缓paths鍐呴儴绱㈠紩
     * 
     * @inner
     */
    function createPathsIndex() {
        pathsIndex = kv2List(requireConf.paths);
        pathsIndex.sort(createDescSorter());
    }

    /**
     * 榛樿鐨剈rlArgs
     * 
     * @inner
     * @type {string}
     */
    var defaultUrlArgs;

    /**
     * urlArgs鍐呴儴绱㈠紩
     * 
     * @inner
     * @type {Array}
     */
    var urlArgsIndex;

    /**
     * 鍒涘缓urlArgs鍐呴儴绱㈠紩
     * 
     * @inner
     */
    function createUrlArgsIndex() {
        urlArgsIndex = kv2List(requireConf.urlArgs);
        urlArgsIndex.sort(createDescSorter());
    }

    /**
     * mapping鍐呴儴绱㈠紩
     * 
     * @inner
     * @type {Array}
     */
    var mappingIdIndex;

    /**
     * 鍒涘缓mapping鍐呴儴绱㈠紩
     * 
     * @inner
     */
    function createMappingIdIndex() {
        mappingIdIndex = [];

        mappingIdIndex = kv2List(requireConf.map);
        mappingIdIndex.sort(createDescSorter());

        each(
            mappingIdIndex,
            function (item) {
                var key = item.k;
                item.v = kv2List(item.v);
                item.v.sort(createDescSorter());
                item.reg = key == '*'
                    ? /^/
                    : createPrefixRegexp(key);
            }
        );
    }

    /**
     * 灏哷妯″潡鏍囪瘑+'.extension'`褰㈠紡鐨勫瓧绗︿覆杞崲鎴愮浉瀵圭殑url
     * 
     * @inner
     * @param {string} source 婧愬瓧绗︿覆
     * @return {string}
     */
    function toUrl(source) {
        // 鍒嗙 妯″潡鏍囪瘑 鍜� .extension
        var extReg = /(\.[a-z0-9]+)$/i;
        var queryReg = /(\?[^#]*)$/i;
        var extname = '.js';
        var id = source;
        var query = '';

        if (queryReg.test(source)) {
            query = RegExp.$1;
            source = source.replace(queryReg, '');
        }

        if (extReg.test(source)) {
            extname = RegExp.$1;
            id = source.replace(extReg, '');
        }

        // 妯″潡鏍囪瘑鍚堟硶鎬ф娴�
        if (!MODULE_ID_REG.test(id)) {
            return source;
        }

        var url = id;

        // paths澶勭悊鍜屽尮閰�
        var isPathMap;
        each(pathsIndex, function (item) {
            var key = item.k;
            if (createPrefixRegexp(key).test(id)) {
                url = url.replace(key, item.v);
                isPathMap = 1;
                return false;
            }
        });

        // packages澶勭悊鍜屽尮閰�
        if (!isPathMap) {
            each(
                packagesIndex,
                function (packageConf) {
                    var name = packageConf.name;
                    if (createPrefixRegexp(name).test(id)) {
                        url = url.replace(name, packageConf.location);
                        return false;
                    }
                }
            );
        }

        // 鐩稿璺緞鏃讹紝闄勫姞baseUrl
        if (!/^([a-z]{2,10}:\/)?\//i.test(url)) {
            url = requireConf.baseUrl + url;
        }

        // 闄勫姞 .extension 鍜� query
        url += extname + query;


        var isUrlArgsAppended;

        /**
         * 涓簎rl闄勫姞urlArgs
         * 
         * @inner
         * @param {string} args urlArgs涓�
         */
        function appendUrlArgs(args) {
            if (!isUrlArgsAppended) {
                url += (url.indexOf('?') > 0 ? '&' : '?') + args;
                isUrlArgsAppended = 1;
            }
        }

        // urlArgs澶勭悊鍜屽尮閰�
        each(urlArgsIndex, function (item) {
            if (createPrefixRegexp(item.k).test(id)) {
                appendUrlArgs(item.v);
                return false;
            }
        });
        defaultUrlArgs && appendUrlArgs(defaultUrlArgs);

        return url;
    }

    /**
     * 鍒涘缓local require鍑芥暟
     * 
     * @inner
     * @param {number} baseId 褰撳墠module id
     * @return {Function}
     */
    function createLocalRequire(baseId) {
        var requiredCache = {};
        function req(requireId, callback) {
            if (isString(requireId)) {
                var requiredModule;
                if (!(requiredModule = requiredCache[requireId])) {
                    requiredModule = nativeRequire(
                        normalize(requireId, baseId),
                        callback,
                        baseId
                    );
                    requiredCache[requireId] = requiredModule;
                }

                return requiredModule;
            }
            else if (isArray(requireId)) {
                // 鍒嗘瀽鏄惁鏈塺esource浣跨敤鐨刾lugin娌″姞杞�
                var unloadedPluginModules = [];
                each(
                    requireId,
                    function (id) {
                        var idInfo = parseId(id);
                        var pluginId = normalize(idInfo.module, baseId);
                        if (idInfo.resource && !modIsDefined(pluginId)) {
                            unloadedPluginModules.push(pluginId);
                        }
                    }
                );

                // 鍔犺浇妯″潡
                nativeRequire(
                    unloadedPluginModules,
                    function () {
                        var ids = [];
                        each(
                            requireId,
                            function (id) {
                                ids.push(normalize(id, baseId));
                            }
                        );
                        nativeRequire(ids, callback, baseId);
                    },
                    baseId
                );
            }
        }

        /**
         * 灏哰module ID] + '.extension'鏍煎紡鐨勫瓧绗︿覆杞崲鎴恥rl
         * 
         * @inner
         * @param {string} source 绗﹀悎鎻忚堪鏍煎紡鐨勬簮瀛楃涓�
         * @return {string} 
         */
        req.toUrl = function (id) {
            return toUrl(normalize(id, baseId));
        };

        return req;
    }

    /**
     * id normalize鍖�
     * 
     * @inner
     * @param {string} id 闇€瑕乶ormalize鐨勬ā鍧楁爣璇�
     * @param {string} baseId 褰撳墠鐜鐨勬ā鍧楁爣璇�
     * @return {string}
     */
    function normalize(id, baseId) {
        if (!id) {
            return '';
        }

        var idInfo = parseId(id);
        if (!idInfo) {
            return id;
        }

        var resourceId = idInfo.resource;
        var moduleId = relative2absolute(idInfo.module, baseId);

        each(
            packagesIndex,
            function (packageConf) {
                var name = packageConf.name;
                var main = name + '/' + packageConf.main;
                if (name == moduleId
                ) {
                    moduleId = moduleId.replace(name, main);
                    return false;
                }
            }
        );

        moduleId = mappingId(moduleId, baseId);

        if (resourceId) {
            var module = modGetModuleExports(moduleId);
            resourceId = module && module.normalize
                ? module.normalize(
                    resourceId,
                    function (resId) {
                        return normalize(resId, baseId);
                    }
                  )
                : normalize(resourceId, baseId);

            return moduleId + '!' + resourceId;
        }

        return moduleId;
    }

    /**
     * 鐩稿id杞崲鎴愮粷瀵筰d
     * 
     * @inner
     * @param {string} id 瑕佽浆鎹㈢殑id
     * @param {string} baseId 褰撳墠鎵€鍦ㄧ幆澧僫d
     * @return {string}
     */
    function relative2absolute(id, baseId) {
        if (/^\.{1,2}/.test(id)) {
            var basePath = baseId.split('/');
            var namePath = id.split('/');
            var baseLen = basePath.length - 1;
            var nameLen = namePath.length;
            var cutBaseTerms = 0;
            var cutNameTerms = 0;

            pathLoop: for (var i = 0; i < nameLen; i++) {
                var term = namePath[i];
                switch (term) {
                    case '..':
                        if (cutBaseTerms < baseLen) {
                            cutBaseTerms++;
                            cutNameTerms++;
                        }
                        else {
                            break pathLoop;
                        }
                        break;
                    case '.':
                        cutNameTerms++;
                        break;
                    default:
                        break pathLoop;
                }
            }

            basePath.length = baseLen - cutBaseTerms;
            namePath = namePath.slice(cutNameTerms);

            basePath.push.apply(basePath, namePath);
            return basePath.join('/');
        }

        return id;
    }

    /**
     * 纭畾require鐨勬ā鍧梚d涓嶅寘鍚浉瀵筰d銆傜敤浜巊lobal require锛屾彁鍓嶉闃查毦浠ヨ窡韪殑閿欒鍑虹幇
     * 
     * @inner
     * @param {string|Array} requireId require鐨勬ā鍧梚d
     */
    function assertNotContainRelativeId(requireId) {
        var invalidIds = [];

        /**
         * 鐩戞祴妯″潡id鏄惁relative id
         * 
         * @inner
         * @param {string} id 妯″潡id
         */
        function monitor(id) {
            if (/^\.{1,2}/.test(id)) {
                invalidIds.push(id);
            }
        }

        if (isString(requireId)) {
            monitor(requireId);
        }
        else {
            each(
                requireId,
                function (id) {
                    monitor(id);
                }
            );
        }

        // 鍖呭惈鐩稿id鏃讹紝鐩存帴鎶涘嚭閿欒
        if (invalidIds.length > 0) {
            throw new Error(
                '[REQUIRE_FATAL]Relative ID is not allowed in global require: '
                + invalidIds.join(', ')
            );
        }
    }

    /**
     * 妯″潡id姝ｅ垯
     * 
     * @const
     * @inner
     * @type {RegExp}
     */
    var MODULE_ID_REG = /^[-_a-z0-9\.]+(\/[-_a-z0-9\.]+)*$/i;

    /**
     * 瑙ｆ瀽id锛岃繑鍥炲甫鏈塵odule鍜宺esource灞炴€х殑Object
     * 
     * @inner
     * @param {string} id 鏍囪瘑
     * @return {Object}
     */
    function parseId(id) {
        var segs = id.split('!');

        if (MODULE_ID_REG.test(segs[0])) {
            return {
                module: segs[0],
                resource: segs[1] || ''
            };
        }

        return null;
    }

    /**
     * 鍩轰簬map閰嶇疆椤圭殑id鏄犲皠
     * 
     * @inner
     * @param {string} id 妯″潡id
     * @param {string} baseId 褰撳墠鐜鐨勬ā鍧梚d
     * @return {string}
     */
    function mappingId(id, baseId) {
        each(
            mappingIdIndex,
            function (item) {
                if (item.reg.test(baseId)) {

                    each(item.v, function (mapData) {
                        var key = mapData.k;
                        var rule = createPrefixRegexp(key);

                        if (rule.test(id)) {
                            id = id.replace(key, mapData.v);
                            return false;
                        }
                    });

                    return false;
                }
            }
        );

        return id;
    }

    /**
     * 灏嗗璞℃暟鎹浆鎹㈡垚鏁扮粍锛屾暟缁勬瘡椤规槸甯︽湁k鍜寁鐨凮bject
     * 
     * @inner
     * @param {Object} source 瀵硅薄鏁版嵁
     * @return {Array.<Object>}
     */
    function kv2List(source) {
        var list = [];
        for (var key in source) {
            if (source.hasOwnProperty(key)) {
                list.push({
                    k: key,
                    v: source[key]
                });
            }
        }

        return list;
    }

    // 鎰熻阿requirejs锛岄€氳繃currentlyAddingScript鍏煎鑰佹棫ie
    // 
    // For some cache cases in IE 6-8, the script executes before the end
    // of the appendChild execution, so to tie an anonymous define
    // call to the module name (which is stored on the node), hold on
    // to a reference to this node, but clear after the DOM insertion.
    var currentlyAddingScript;
    var interactiveScript;

    /**
     * 鑾峰彇褰撳墠script鏍囩
     * 鐢ㄤ簬ie涓媎efine鏈寚瀹歮odule id鏃惰幏鍙杋d
     * 
     * @inner
     * @return {HTMLDocument}
     */
    function getCurrentScript() {
        if (currentlyAddingScript) {
            return currentlyAddingScript;
        }
        else if (
            interactiveScript
            && interactiveScript.readyState == 'interactive'
        ) {
            return interactiveScript;
        }
        else {
            var scripts = document.getElementsByTagName('script');
            var scriptLen = scripts.length;
            while (scriptLen--) {
                var script = scripts[scriptLen];
                if (script.readyState == 'interactive') {
                    interactiveScript = script;
                    return script;
                }
            }
        }
    }

    /**
     * 鍚戦〉闈腑鎻掑叆script鏍囩
     * 
     * @inner
     * @param {HTMLScriptElement} script script鏍囩
     */
    function appendScript(script) {
        currentlyAddingScript = script;

        var doc = document;
        (doc.getElementsByTagName('head')[0] || doc.body).appendChild(script);

        currentlyAddingScript = null;
    }

    /**
     * 鍒涘缓id鍓嶇紑鍖归厤鐨勬鍒欏璞�
     * 
     * @inner
     * @param {string} prefix id鍓嶇紑
     * @return {RegExp}
     */
    function createPrefixRegexp(prefix) {
        return new RegExp('^' + prefix + '(/|$)');
    }

    /**
     * 鍒ゆ柇瀵硅薄鏄惁鏁扮粍绫诲瀷
     * 
     * @inner
     * @param {*} obj 瑕佸垽鏂殑瀵硅薄
     * @return {boolean}
     */
    function isArray(obj) {
        return obj instanceof Array;
    }

    /**
     * 鍒ゆ柇瀵硅薄鏄惁鍑芥暟绫诲瀷
     * 
     * @inner
     * @param {*} obj 瑕佸垽鏂殑瀵硅薄
     * @return {boolean}
     */
    function isFunction(obj) {
        return typeof obj == 'function';
    }

    /**
     * 鍒ゆ柇鏄惁瀛楃涓�
     * 
     * @inner
     * @param {*} obj 瑕佸垽鏂殑瀵硅薄
     * @return {boolean}
     */
    function isString(obj) {
        return typeof obj == 'string';
    }

    /**
     * 寰幆閬嶅巻鏁扮粍闆嗗悎
     * 
     * @inner
     * @param {Array} source 鏁扮粍婧�
     * @param {function(Array,Number):boolean} iterator 閬嶅巻鍑芥暟
     */
    function each(source, iterator) {
        if (isArray(source)) {
            for (var i = 0, len = source.length; i < len; i++) {
                if (iterator(source[i], i) === false) {
                    break;
                }
            }
        }
    }

    /**
     * 鍒涘缓鏁扮粍瀛楃鏁伴€嗗簭鎺掑簭鍑芥暟
     * 
     * @inner
     * @param {string} property 鏁扮粍椤瑰璞″悕
     * @return {Function}
     */
    function createDescSorter(property) {
        property = property || 'k';

        return function (a, b) {
            var aValue = a[property];
            var bValue = b[property];

            if (bValue == '*') {
                return -1;
            }

            if (aValue == '*') {
                return 1;
            }

            return bValue.length - aValue.length;
        };
    }

    // 鏆撮湶鍏ㄥ眬瀵硅薄
    global.define = define;
    global.require = require;
})(this);