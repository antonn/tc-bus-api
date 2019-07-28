# Topcoder - Submission Processor APM OpenTracing

## Applying the patch

Checkout commit id `8de55b337243895d174ae595433c5ac41ffb733b` on the `develop` branch of `submission processor`
Now apply the patch using `git apply ../0001-Add-tracing.patch`

## Testing

Note that according to the forum discussion, SignalFX can be turned off as we are having trouble getting it to work.

Nonetheless, I've still included the documentation for the setup. You can ignore it.

Also, SignalFX Gateway runs only on linux so you will need to run on linux OS if you need to test SignalFX.

### Datadog setup

1. Signup to datadog and get a 14 day free trial if you haven't already from https://www.datadoghq.com/.

2. Install the agent for your OS: https://docs.datadoghq.com/agent/?tab=agentv6

3. Enable trace collection for the Datadog Agent: https://docs.datadoghq.com/agent/apm/?tab=agent630#agent-configuration.

  ```
  # Trace Agent Specific Settings
      apm_config:
        enabled: true
  ```

You can find the location of `datadog.yml` on your OS, here: https://docs.datadoghq.com/agent/guide/agent-configuration-files/?tab=agentv6.

4. If you're on a mac, you need to install and run the Trace Agent in addition to the Datadog Agent: https://github.com/DataDog/datadog-agent/tree/master/docs/trace-agent#run-on-macos. Download the `amd64` file `trace-agent-6.10.0-darwin-amd64`.

  Then, run,

  `./trace-agent-6.10.0-darwin-amd64 -config ~/.datadog-agent/datadog.yaml`

5. Start / Restart the datadog-agent: `datadog-agent start`
   See https://docs.datadoghq.com/agent/guide/agent-commands/?tab=agentv6 for agent commands list

If you're stuck, you can find the official docs here, https://docs.datadoghq.com/agent/apm/?tab=agent630. See Section `Setup process`.

### LightStep setup

The credentials provided in the forum are not enough to sign in and view the dashboard. You will need to,

1. Signup for the 30 day trial `Lightstep tracing` plan from here: https://lightstep.com/products/

2. On the dashboard, click on Settings to view your `component name` (name) and `access token`. Make a note of these values.

### SignalFX setup

You can follow the documentation from here https://docs.signalfx.com/en/latest/apm/apm-quick-start/apm-quick-start.html

The main steps are,

1. Signup for a free trial of SignalFX from https://www.signalfx.com/ 

2. Login to your account and click Integrations

3. Setup SignalFx SmartAgent. See `agent.yaml` for my config file. You need to place your access token in a file at `/etc/signalfx/token`

4. Setup SignalFx Gateway. See `gateway.conf` for my config file.

You can find your token from `Settings` -> `Organization Settings` -> `Access tokens`

Basically, submission-processor sends traces to SmartAgent on port 9080. SmartAgent forwards those traces to Gateway on port 8080. Gateway forwards traces to TraceURL.

### Submission-processor setup

1. Update config file with tokens from above. 

2. Update AWS credentials. 

3. Update M2M credentials. Optionally you can disable m2m tokens as we are using mock submission api. Change line 45 `const token = yield getM2Mtoken(span)` in `helper.js : reqToSubmissionAPI` and remove the call to `getM2Mtoken` and set token to some constant.

4. Follow `README.md` to deploy and verify by passing in messages in the kafka console.

### Verifying APM traces

After each scenario you will see traces captured on the dashboards of datadog, lightstep and signalfx.

On DataDog, click on APM -> Trace list.

On LightStep, click on explorer -> select your service (component name) -> click Run

On SignalFX, click uAPM -> Traces

## Important notes

1. I have added 
```
  app.get('/api/v5/reviewTypes', (req, res) => {
    logger.info('Mock Submission API get review type')
    res.status(200).end() // return null
  })
```
to `mock-submission-api` -> `api.js` as it is required by `helper.js` -> `getreviewTypeId`

2. The names of non custom span tags are from the opentracing conventions at https://github.com/opentracing/specification/blob/master/semantic_conventions.md#span-tags-table

3. Npm audit shows one moderate warning https://github.com/nestjs/nest/issues/2322#issuecomment-498437525.
This warning is actually fixed as axios is updated to 0.19 which is >=0.18.1. 
See https://github.com/axios/axios/issues/1098#issuecomment-497424749.

4. According to the forum discussion https://apps.topcoder.com/forums/?module=Thread&threadID=938289&start=0.

The copilot mentioned "If you think something could be time-consuming and worths covering with a separate child span, go ahead and cover it" for helper methods.

The helper methods are indeed time consuming as they call external services. Hence, I have added child spans for those methods.
