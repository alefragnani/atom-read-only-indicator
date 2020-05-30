<p align="center">
  <br />
  <a title="Learn more about Read-only Indicator" href="http://github.com/alefragnani/atom-read-only-indicator"><img src="https://raw.githubusercontent.com/alefragnani/atom-read-only-indicator/master/images/atom-read-only-indicator-logo-readme.png" alt="Read-only Logo" width="70%" /></a>
</p>

# What's new in Read-only Indicator 0.9

* Adds **Clickable** Status Bar indicator
* Adds **Auto-refresh** behavior for changes outside Atom

## Support

**Read-only Indicator** is an open source extension created for **Atom**. While being free and open source, if you find it useful, please consider supporting it.

<table align="center" width="60%" border="0">
 <tr>
   <td>
     <a title="Paypal" href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=EP57F3B6FXKTU&lc=US&item_name=Alessandro%20Fragnani&item_number=atom%20plugins&currency_code=USD&bn=PP%2dDonationsBF%3abtn_donateCC_LG%2egif%3aNonHosted"><img src="https://www.paypalobjects.com/en_US/i/btn/btn_donate_SM.gif"/></a>
   </td>
   <td>
     <a title="Paypal" href="https://www.paypal.com/cgi-bin/webscr?cmd=_donations&business=EP57F3B6FXKTU&lc=BR&item_name=Alessandro%20Fragnani&item_number=atom%20plugins&currency_code=BRL&bn=PP%2dDonationsBF%3abtn_donate_SM%2egif%3aNonHosted"><img src="https://www.paypalobjects.com/pt_BR/i/btn/btn_donate_SM.gif"/></a>
   </td>
   <td>
     <a title="Patreon" href="https://www.patreon.com/alefragnani"><img src="https://raw.githubusercontent.com/alefragnani/oss-resources/master/images/button-become-a-patron-rounded-small.png"/></a>
   </td>
 </tr>
</table>

# Read-only Indicator

It adds an area in the status bar, indicating if the file is **read-only** or **writeable**. It will be automatically updated, every time you open any file.

## Screenshots

The indicator is automatically updated. You don't need to do anything.

File Access | Status Bar Preview |
----------- | ------------------ |
Read-only |![Read-only](https://raw.githubusercontent.com/alefragnani/atom-read-only-indicator/master/images/readonly.png)
Writeable |![Writeable](https://raw.githubusercontent.com/alefragnani/atom-read-only-indicator/master/images/writeable.png)

## Available Settings

* Define the position where the Status Bar indicator is located
```cson
    "read-only-indicator":
      position: "left" # or "right"
```

* Define how much information is displayed in the Status Bar indicator
```cson
    "read-only-indicator":
      showIcon: true # or false
```

* Define if the Status Bar indicator should automatically be updated when the file is changed outside Atom
```cson
    "read-only-indicator":
      autorefresh: true # or false
```

* Define if the Status Bar indicator should accept clicks to change the file access
```cson
    "read-only-indicator":
      clicktochangerw: true # or false
```

## Contributors

Special thanks to the people that have contributed to the project:

* (@jmtoniolo) - Click on status bar to change file access [PR #10](https://github.com/alefragnani/atom-read-only-indicator/pull/10))
* (@jmtoniolo) - Auto-refresh status bar on external file change [PR #10](https://github.com/alefragnani/atom-read-only-indicator/pull/10))

# License

[MIT](LICENSE.md) &copy; Alessandro Fragnani
