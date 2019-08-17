ruleset logging {
  meta {
    logging off
    shares __testing, fmtLogs
  }
  global {
    __testing = { "queries":
      [ { "name": "__testing" }
      , { "name": "fmtLogs", "args": [ "url" ] }
      ] , "events":
      [ //{ "domain": "d1", "type": "t1" }
      //, { "domain": "d2", "type": "t2", "attrs": [ "a1", "a2" ] }
      ]
    }
    fmtLogs = function(url){
      episode_line = function(x,i){
        level = x{"krl_level"}.uc();
        x{"time"}+" | [" + level + "] "+x{"msg"}
      };
      episode = function(log_entries,key){
        first_line = log_entries[0];
        {}.put(
          first_line{"time"}+" | "+first_line{"msg"},
          log_entries.map(episode_line)
        )
      };
      http:get(url){"content"}
        .extract(re#(.+)#g)
        .map(function(x){x.decode()})
        .sort(function(a,b){a{"time"} cmp b{"time"}})
        .collect(function(x){x{["context","txn_id"]}})
        .map(episode)
        .values()
        .reverse()
        .reduce(function(a,x){a.put(x)},{})
    }
  }
}
