reStructuredText 语法
=====================

一级标题

Example::

    一级标题
    ========

----

二级标题    

Example::

    二级标题
    --------

----

普通段落

Example::

    普通段落

----

*斜体*

Example::

    *斜体*

----

**粗体**

Example::

    **粗体**

----

``代码示例``

Example::

    ``代码示例``

----

代码块::

    mkdir -p /root/.pip
    cat >  /root/.pip/pip.conf   <<EOF
    [global]
    index-url = http://pypi.douban.com/simple
    trusted-host = pypi.douban.com
    EOF

Example::

    代码块::

        mkdir -p /root/.pip
        cat >  /root/.pip/pip.conf   <<EOF
        [global]
        index-url = http://pypi.douban.com/simple
        trusted-host = pypi.douban.com
        EOF

----

无序列表

* This is a bulleted list.
* It has two items, the second
  item uses two lines.

Example::

    * This is a bulleted list.
    * It has two items, the second
      item uses two lines.

----

有序列表

#. This is a numbered list.
#. It has two items too.
#. This is a numbered list.
#. It has two items too.

Example::

    #. This is a numbered list.
    #. It has two items too.

    #. This is a numbered list.
    #. It has two items too.

----

嵌套列表

* this is
* a list

  * with a nested list
  * and some subitems

* and here the parent list continues

Example::

    * this is
    * a list

      * with a nested list
      * and some subitems

    * and here the parent list continues

----

自定义列表

term (up to a line of text)
   Definition of the term, which must be indented

   and can even consist of multiple paragraphs

next term
   Description.

Example::

    term (up to a line of text)
       Definition of the term, which must be indented

       and can even consist of multiple paragraphs

    next term
       Description.

----

.. tip:: This is a Tip!
         提示!!!

Example::

    .. attention:: This is a Attention!
    .. caution:: This is a Caution!
    .. danger:: This is a Danger!
    .. error:: This is a Error!
    .. hint:: This is a Hint!
    .. important:: This is a Important!
    .. note:: This is a Note!
    .. tip:: This is a Tip!
    .. warning:: This is a Warning!


----

.. attention:: This is a Attention !

    \.. attention:: This is a Attention !

----

.. caution:: This is a Caution !

    \.. caution:: This is a Caution !

----

.. danger:: This is a Danger !

    \.. danger:: This is a Danger !

----

.. error:: This is a Error !

    \.. error:: This is a Error !

----

.. hint:: This is a Hint !

    \.. hint:: This is a Hint !

----

.. important:: This is Important !

    \.. important:: This is Important !

----

.. note:: This is a Note !

    \.. note:: This is a Note !

----

.. tip:: This is a Tip !

   \.. tip:: This is a Tip !

----

.. warning:: This is a Warning !

    \.. warning:: This is a Warning !

----

表格

.. list-table:: Frozen Delights!
   :widths: 10 5 30
   :header-rows: 0
   :stub-columns: 0

   * - Treat
     - Quantity
     - Description
   * - Albatross
     - 2.99
     - On a stick!
   * - Crunchy Frog
     - 1.49
     - If we took the bones out, it wouldn
       crunchy, now would it?
   * - Gannet Ripple
     - 1.99
     - On a stick!

Example::

    .. list-table:: Frozen Delights!
       :widths: 10 5 30
       :header-rows: 0
       :stub-columns: 0

       * - Treat
         - Quantity
         - Description
       * - Albatross
         - 2.99
         - On a stick!
       * - Crunchy Frog
         - 1.49
         - If we took the bones out, it wouldn't be
           crunchy, now would it?
       * - Gannet Ripple
         - 1.99
         - On a stick!
