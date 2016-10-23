# Dynvar

DynVar provides dynamic variables for ruby language.

Usage example:
``lang=ruby
  Context = DynVar.initialize({})
  Context.set(locale: :ru) do
  puts "Your locale is #{Context.get[:locale]}!"
  end
```

## Reason

Dynamic variables are cool solution to throw contexts.
Look at `I18n.with_locale` from i18n gem, it is thread-unsafe.
Why they implemented it thread-unsafe? Cose f*ck you, that's why.

There is no clear way to implement really thread-safe methods like that,
this damage could obly be reduced to raise an error if called inside
a new thread. Green threads does not solve this problem, because thread
could be paused by a system call
