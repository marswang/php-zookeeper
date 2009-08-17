dnl
dnl $ Id: $
dnl vim:se ts=2 sw=2 et:

PHP_ARG_ENABLE(zookeeper, whether to enable zookeeper support,
[  --enable-zookeeper               Enable zookeeper support])

PHP_ARG_WITH(libzookeeper-dir,  for libzookeeper,
[  --with-libzookeeper-dir[=DIR]   Set the path to libzookeeper install prefix.], yes)

  if test -z "$PHP_DEBUG"; then
    AC_ARG_ENABLE(debug,
    [  --enable-debug          compile with debugging symbols],[
      PHP_DEBUG=$enableval
    ],[    PHP_DEBUG=no
    ])
  fi

  if test "$PHP_LIBZOOKEEPER_DIR" != "no" && test "$PHP_LIBZOOKEEPER_DIR" != "yes"; then
    if test -r "$PHP_LIBZOOKEEPER_DIR/include/c-client-src/zookeeper.h"; then
      PHP_LIBZOOKEEPER_DIR="$PHP_LIBZOOKEEPER_DIR"
    else
      AC_MSG_ERROR([Can't find zookeeper headers under "$PHP_LIBZOOKEEPER_DIR"])
    fi
  else
    PHP_LIBZOOKEEPER_DIR="no"
    for i in /usr /usr/local; do
	    if test -r "$i/include/libzookeeper/zookeeper.h"; then
	  	  PHP_LIBZOOKEEPER_DIR=$i
	  	  break
	    fi
	  done
  fi

  AC_MSG_CHECKING([for libzookeeper location])
  if test "$PHP_LIBZOOKEEPER_DIR" = "no"; then
    AC_MSG_ERROR([zookeeper support requires libzookeeper. Use --with-libzookeeper-dir=<DIR> to specify the prefix where libzookeeper headers and library are located])
  else
    AC_MSG_RESULT([$PHP_LIBZOOKEEPER_DIR])
    PHP_LIBZOOKEEPER_INCDIR="$PHP_LIBZOOKEEPER_DIR/include/c-client-src"
    PHP_ADD_INCLUDE($PHP_LIBZOOKEEPER_INCDIR)
    PHP_ADD_LIBRARY_WITH_PATH(zookeeper, $PHP_LIBZOOKEEPER_DIR/lib, ZOOKEEPER_SHARED_LIBADD)

    PHP_SUBST(ZOOKEEPER_SHARED_LIBADD)
    PHP_NEW_EXTENSION(zookeeper, php_zookeeper.c , $ext_shared,,)

  fi

fi

