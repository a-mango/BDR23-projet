import { useRoutes } from 'react-router-dom';
import {routes} from './routes';

const Router = () => {
    let routing = useRoutes(routes);

    return routing;
}

export default Router;