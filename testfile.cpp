module;

#include "macros.hpp"

#if defined(HE_DEBUG)
#    if __has_builtin(__builtin_debugtrap)
#        define HE_DEBUGBREAK() __builtin_debugtrap()
#    elif defined(PLATFORM_WINDOWS)
#        define HE_DEBUGBREAK() __debugbreak()
#    elif defined(PLATFORM_LINUX || PLATFORM_MACOS)
#        include <signal.h>
#        define HE_DEBUGBREAK() raise(SIGTRAP)
#    else
#        error "Platform doesn't support debugbreak yet!"
#    endif
#    define HE_ENABLE_ASSERTS
#else
#    define HE_DEBUGBREAK()
#endif

void(int asdf)

#if defined(HE_DEBUG)
#    if defined(PLATFORM_LINX || PLATFORM_MACOS)
#        include <signal.h>
#    endif
#endif

export module assert;

namespace HE_NAMESPACE::debug
{
    consteval void DebugBreak() {
        if (__has_builtin(__builtin_debugtrap)) {
            return __builtin_debugtrap();
        }
        elif (PLATFORM_WINDOWS) {
            __debugbreak();
        }
        elif (PLATFORM_LINUX || PLATFORM_MACOS) {
            raise(SIGTRAP);
        }
        else {
            throw "Invalid Platform";
        }
    }

    export consteval void Assert(bool condition) {
        if (HE_DEBUG && HELIUM_TESTABLE_ASSERTIONS) {
            throw true;
        }
        elif (HE_DEBUG) {
            DebugBreak();
        }
        else {
            // Do nothing
        }
    }
}   // namespace HE_NAMESPACE::debug

/*

#if HELIUM_TESTABLE_ASSERTIONS
#    if HE_HAS_NOEXCEPT
#        error "NOEXCEPT must be turned off during testing."
#    endif
#    define HE_ASSERT(...) throw 1;
#elif defined(HE_ENABLE_ASSERTS)
// Alteratively we could use the same "default" message for both "WITH_MSG" and
// "NO_MSG" and provide support for custom formatting by concatenating the
// formatting string instead of having the format inside the default message
#    define HE_INTERNAL_ASSERT_IMPL(type, check, msg, ...) \
        {                                                  \
            if (!(check)) {                                \
                HE##type##ERROR(msg, __VA_ARGS__);         \
                HE_DEBUGBREAK();                           \
            }                                              \
        }
#    define HE_INTERNAL_ASSERT_WITH_MSG(type, check, ...)                          \
        HE_INTERNAL_ASSERT_IMPL(type, check, "Assertion failed: {0}", __VA_ARGS__)
#    define HE_INTERNAL_ASSERT_NO_MSG(type, check)                                         \
        HE_INTERNAL_ASSERT_IMPL(                                                           \
          type, check, "Assertion '{0}' failed at {1}:{2}", HE_STRINGIFY(check), __FILE__, \
          __LINE__)

#    define HE_INTERNAL_ASSERT_GET_MACRO_NAME(arg1, arg2, macro, ...) macro
#    define HE_INTERNAL_ASSERT_GET_MACRO(...)                                   \
        HE_EXPAND_MACRO(HE_INTERNAL_ASSERT_GET_MACRO_NAME(                      \
          __VA_ARGS__, HE_INTERNAL_ASSERT_WITH_MSG, HE_INTERNAL_ASSERT_NO_MSG))

// Currently accepts at least the condition and one additional parameter (the
// message) being optional
#    define HE_ASSERT(...)                                                         \
        HE_EXPAND_MACRO(HE_INTERNAL_ASSERT_GET_MACRO(__VA_ARGS__)(_, __VA_ARGS__))
// #define HE_CORE_ASSERT(...) HE_EXPAND_MACRO(
// HE_INTERNAL_ASSERT_GET_MACRO(__VA_ARGS__)(_CORE_, __VA_ARGS__) )
#else
#    define HE_ASSERT(...)
// #define HE_CORE_ASSERT(...)
#endif
*/

