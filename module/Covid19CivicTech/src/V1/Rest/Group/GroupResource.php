<?php
namespace Covid19CivicTech\V1\Rest\Group;

use Covid19CivicTech\V1\Rest\Group\Model\RepositoryInterface;
use Laminas\ApiTools\ApiProblem\ApiProblem;
use Laminas\ApiTools\Rest\AbstractResourceListener;

class GroupResource extends AbstractResourceListener
{
    /**
     * @var RepositoryInterface
     */
    private $repository;

    public function __construct(RepositoryInterface $repository)
    {
        $this->repository = $repository;
    }

    /**
     * Fetch a resource
     *
     * @param  mixed $id
     * @return ApiProblem|mixed
     */
    public function fetch($id)
    {
        return $this->repository->fetchById($id);
    }

    /**
     * Fetch all or a subset of resources
     *
     * @param  array $params
     * @return ApiProblem|mixed
     */
    public function fetchAll($params = [])
    {
        if (isset($params['countryId'])) {
            $this->repository->addFilterByCountryForCollection((int) $params['countryId']);
        }

        return $this->repository->getCollection();
    }
}
