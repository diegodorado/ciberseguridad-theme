var path = require('path');

module.exports = function() {
    var src = './src/';
    var clientApp = src +  'app/';
    var temp = './.tmp/';
    var build = './build/';

    var config = {

        temp: temp,
        allSass: src + 'sass/**/*.sass',

        alljs: [
            './src/**/*.js',
            './*.js'
        ],
        build: build,
        src: src,
        coffee: clientApp + '/**/*.coffee',
        compassConfig: {
            project: path.join(__dirname, './'),
            import_path: './bower_components',
            css: build + 'assets/css',
            sass: src + 'sass',
            image: build + 'assets/images',
            font: build + 'assets/fonts',
        },
        css: build + 'assets/css/app.css',
        fonts: [
            src + 'fonts/**/*.*'
        ],
        html: src + '**/*.htm',
        htmltemplates: clientApp + '**/*.html',
        images: src + 'images/**/*.*',
        index: build + 'layouts/default.htm',
        js: [
          temp + '**/*.module.js',
          temp + '**/*.js',
          temp + 'templates.js',
        ],
        bower: {
            json: require('./bower.json'),
            directory: './bower_components/',
            ignorePath: '../..'
        },
        packages: [
            './package.json',
            './bower.json'
        ],

        rsyncOptions: {
            destination: '/home/deploy/staging/current/themes/ciberseguridad',
            root: build,
            hostname: 'staging.cybersecurityinlac.com',//'185.67.0.172',
            username: 'deploy',
            incremental: true,
            progress: true,
            relative: true,
            //emptyDirectories: true,
            recursive: true,
            clean: true,
            exclude: ['.DS_Store'],
        },



        sass: src + 'sass/app.sass',

        sprites:{
          src: src + 'sprites/**/*.png',
          options:{
            // Filter out `-2x` (retina) images to separate spritesheet
            //   e.g. `github-2x.png`, `twitter-2x.png`
            retinaSrcFilter: src + 'sprites/**/*-2x.png',
            // Generate a normal and a `-2x` (retina) spritesheet
            imgName: 'spritesheet.png',
            imgPath: '../images/spritesheet.png',
            retinaImgName: 'spritesheet-2x.png',
            retinaImgPath: '../images/spritesheet-2x.png',
            padding: 4,
            // Generate SCSS variables/mixins for both spritesheets
            cssName: '_sprites.scss',
            cssVarMap: function (sprite) {
              if(sprite.source_image.indexOf('sprites/flag/')>0){
                sprite.name = 'flag-' + sprite.name;
              }else if(sprite.source_image.indexOf('sprites/logo/')>0){
                sprite.name = 'logo-' + sprite.name;                
              }else{
                sprite.name = 'sprite-' + sprite.name;
              }

            }
          },
          imgDest: src + 'images/',
          scssDest: src + 'sass/partials/',
        },

        /**
        * template cache
        */
        templateCache: {
            file: 'templates.js',
            options: {
                module: 'app.core',
                standAlone: false,
                root: 'app/'
            }
        }

    };

    config.getWiredepDefaultOptions =  function() {
        var options = {
            bowerJson: config.bower.json,
            directory: config.bower.directory,
            ignorePath: config.bower.ignorePath,
        };
        return options;
    };

    return config;
};
