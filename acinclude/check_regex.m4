
AC_DEFUN([CHECK_REGEX], [

AH_TEMPLATE([DISABLE_REGEXP], ["Whether support for regex"])
AC_ARG_ENABLE(regex,
  [AS_HELP_STRING(
    [--(dis|en)able-regex],
    [Whether to use C++11/Boost regular expression support],
   )],
  [
    enable_regexp=$enableval
  ], [
    enable_regexp=yes
  ]
)
if test "X$enable_regexp" = "Xyes"; then
    AM_CONDITIONAL(HAVE_REGEXP, true)
    AC_DEFINE_UNQUOTED([DISABLE_REGEXP], 0, [Compile with support for regex])
    if test "X$with_external_boost" == "Xyes"; then
        AX_BOOST_REGEX
        AC_SUBST(BOOST_REGEX_LIB)
    fi
else
    AM_CONDITIONAL(HAVE_REGEXP, false)
    AC_DEFINE_UNQUOTED([DISABLE_REGEXP], 1, [Do not compile support for regex])
fi

if test "X$enable_cpp11" = "Xyes" && test "X$enable_regexp" = "Xyes"; then
HEADER="#include <iostream> 
        #include <regex>"
BODY="
    const char* text = \"here is 0\";
    const char* regexp = \"\\\d+\";
    std::smatch matches;
    std::regex_constants::match_flag_type searchFlags = std::regex_constants::match_default;
    std::regex re(regexp, std::regex_constants::ECMAScript);
    if (std::regex_search(std::string(text), matches, re, searchFlags)){
        if (matches.size() == 1){
          return 0;
        } else {
          return 1;
        }
    } else {
      return 1;
    }
"

AC_LINK_IFELSE([AC_LANG_PROGRAM([$HEADER], [$BODY])],
[AC_MSG_RESULT([linked successfully against C++11 regex])],
[AC_MSG_FAILURE([C++11 detected, but could not link against regex
Use the flag --disable-regex to disable regex-dependent features
Regex is required for input file proofreading, but sims will still run])]
)

AC_RUN_IFELSE([AC_LANG_PROGRAM([$HEADER], [$BODY])],
[AC_MSG_RESULT([ran C++11 regex test successfully])],
[AC_MSG_FAILURE([C++11 detected, but could not run with regex
This can occur with GCC versions <4.9 which provides an incomplete implentation
Use the flag --disable-regex to disable regex-dependent features
Regex is required for input file proofreading, but sims will still run])]
)
fi

])
